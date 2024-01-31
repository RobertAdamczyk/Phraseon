//
//  PaywallViewModel.swift
//  Phrasify
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
    @Published var user: User?

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
        guard let subscriptionValidUntil = user?.subscriptionValidUntil, let status = user?.subscriptionStatus else { return false }
        return subscriptionValidUntil > .now && status != .trial
    }

    var hasValidSelectedSubscription: Bool {
        guard let user,
              let subscriptionPlan = user.subscriptionPlan else { return false }
        if case .idle(_, selectedProduct) = state, hasValidSubscription {
            switch subscriptionPlan {
            case .basic: return subscriptionPlan.id == self.selectedProduct?.id
            case .gold: return true // if user has gold has also basic
            }
        }
        return false
    }

    var buttonText: String {
        if hasValidSelectedSubscription {
            return "Already bought"
        } else {
            return hasValidSubscription ? "Upgrade Now" : "Subscribe Now"
        }
    }

    var disclaimerTest: String? {
        guard let userSubscriptionPlan = user?.subscriptionPlan, hasValidSubscription else { return nil }
        switch userSubscriptionPlan {
        case .basic:
            return "You are currently subscribed to the Basic plan. Upgrade to Gold for more features!"
        case .gold:
            return "You are currently enjoying our Gold plan – the highest tier of service we offer. Thank you for being a valued subscriber!"
        }
    }

    var userDomain: UserDomain {
        coordinator.dependencies.userDomain
    }

    let cancelBag = CancelBag()

    private let coordinator: PaywallCoordinator

    init(coordinator: PaywallCoordinator) {
        self.coordinator = coordinator
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
        guard let selectedProduct, let subscriptionId = user?.subscriptionId else { return }
        do {
            _ = try await coordinator.dependencies.storeKitRepository.purchase(selectedProduct, with: [.appAccountToken(subscriptionId)])
            ToastView.showSuccess(message: "Thank you for subscribing! Your subscription will be activated shortly.")
            coordinator.dismissFullScreenCover()
        } catch {
            ToastView.showGeneralError()
        }
    }

    private func getProducts() {
        Task {
            do {
                let products = try await coordinator.dependencies.storeKitRepository.getProducts()
                await MainActor.run {
                    if let basic = products.filter({ $0.id == SubscriptionPlan.basic.id }).first {
                        let sortedProducts = products.sorted(by: { $0.price < $1.price })
                        self.state = .idle(sortedProducts, basic)
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

    var plans: [PlanDescription] {
        guard let id = self.selectedProduct?.id else { return [] }
        return switch SubscriptionPlan(rawValue: id) {
        case .basic, .none: [.support, .workflow, .translation, .languages]
        case .gold: PlanDescription.allCases
        }
    }

    enum PlanDescription: CaseIterable {
        case support
        case workflow
        case translation
        case languages
        case members
        case approvals
        case projects

        var text: String {
            switch self {
            case .support: return "Reliable customer support."
            case .workflow: return "Automate your workflow with API access."
            case .translation: return "Automatic phrase translations."
            case .languages: return "Access to a wide range of languages."
            case .members: return "Add multiple members to projects."
            case .approvals: return "Translation reviews and approvals"
            case .projects: return "Unlimited project management."
            }
        }
    }
}
