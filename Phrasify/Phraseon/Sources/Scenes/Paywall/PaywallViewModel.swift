//
//  PaywallViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI
import StoreKit

final class PaywallViewModel: ObservableObject, UserDomainProtocol {

    enum State {
        case loading
        case error
        case idle([Product], Product)
    }

    typealias PaywallCoordinator = Coordinator & FullScreenCoverActions

    @Published private var state: State = .loading
    @Published var user: DeferredData<User>

    var selectedProduct: Product? {
        if case .idle(_, let product) = state {
            return product
        }
        return nil
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    var products: [Product] {
        if case .idle(let products, _) = state {
            return products
        }
        return []
    }

    var hasValidSubscription: Bool {
        guard let subscriptionValidUntil = user.currentValue?.subscriptionValidUntil, 
                let status = user.currentValue?.subscriptionStatus else { return false }
        return subscriptionValidUntil > .now && status != .trial
    }

    var hasValidSelectedSubscription: Bool {
        guard let user = user.currentValue,
              let subscriptionPlan = user.subscriptionPlan else { return false }
        if case .idle(_, selectedProduct) = state, hasValidSubscription {
            switch subscriptionPlan {
            case .monthly: return subscriptionPlan.id == self.selectedProduct?.id
            case .yearly: return true // if user has yearly has also monthly
            }
        }
        return false
    }

    var trialAvailable: Bool {
        let user = user.currentValue
        return user?.subscriptionStatus == nil && user?.subscriptionPlan == nil && user?.subscriptionValidUntil == nil
    }

    var buttonText: String {
        if trialAvailable {
            return "Try for free"
        } else if hasValidSelectedSubscription {
            return "Already bought"
        } else {
            return hasValidSubscription ? "Upgrade Now" : "Subscribe Now"
        }
    }

    var disclaimerTest: String? {
        if trialAvailable {
            return "Start your 7-day free trial now and explore all the features of our platform with no commitment – you won't be charged when your trial ends."
        }
        if let userSubscriptionPlan = user.currentValue?.subscriptionPlan, hasValidSubscription {
            switch userSubscriptionPlan {
            case .monthly:
                return "You are currently subscribed to our Monthly plan. Consider upgrading to the Yearly plan for better pricing over the long term!"
            case .yearly:
                return "You are enjoying full access to our app with the Yearly subscription – thank you for trusting and supporting our project!"
            }
        }
        return nil
    }

    var userDomain: UserDomain {
        coordinator.dependencies.userDomain
    }

    let cancelBag = CancelBag()

    private let coordinator: PaywallCoordinator

    init(coordinator: PaywallCoordinator) {
        self.coordinator = coordinator
        self.user = coordinator.dependencies.userDomain.user
        setupUserSubscriber()
        getProducts()
    }

    func onProductTapped(_ product: Product) {
        if case .idle(let products, _) = state {
            self.state = .idle(products, product)
        }
    }

    @MainActor
    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    @MainActor
    func onSubscribeButtonTapped() async {
        guard let selectedProduct, let subscriptionId = user.currentValue?.subscriptionId else { return }
        do {
            if trialAvailable {
                try await coordinator.dependencies.cloudRepository.startTrial(.init())
                ToastView.showSuccess(message: "Your 7-day trial period has begun. Enjoy full access to all features.")
            } else {
                _ = try await coordinator.dependencies.storeKitRepository.purchase(selectedProduct, with: [.appAccountToken(subscriptionId)])
                ToastView.showSuccess(message: "Thank you for subscribing! Your subscription will be activated shortly.")
            }
            coordinator.dismissFullScreenCover()
        } catch {
            if let appError = error as? AppError {
                switch appError {
                case .purchasePending: ToastView.showSuccess(message: "Your transaction is currently in progress and requires some additional time to complete.")
                case .purchaseGeneralError: ToastView.showGeneralError()
                case .purchaseCancelled: return
                default: ToastView.showGeneralError()
                }
            } else {
                ToastView.showGeneralError()
            }
        }
    }

    private func getProducts() {
        Task {
            do {
                let products = try await coordinator.dependencies.storeKitRepository.getProducts()
                await MainActor.run {
                    if let monthly = products.filter({ $0.id == SubscriptionPlan.monthly.id }).first {
                        let sortedProducts = products.sorted(by: { $0.price < $1.price })
                        self.state = .idle(sortedProducts, monthly)
                    } else {
                        self.state = .error
                    }
                }
            } catch {
                ToastView.showGeneralError()
            }
        }
    }
}

extension PaywallViewModel {

    enum PlanFeature: CaseIterable {
        case support
        case translation
        case collaboration
        case management

        var description: String {
            switch self {
            case .support:
                return "Get 24/7 support for any issue."
            case .translation:
                return "Enjoy seamless translations in numerous languages."
            case .collaboration:
                return "Collaborate effectively with team members."
            case .management:
                return "Manage projects effortlessly with unlimited access."
            }
        }
    }
}
