//
//  PaywallViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI
import StoreKit
import Model
import Domain
import Common

final class PaywallViewModel: ObservableObject, UserDomainProtocol {

    typealias PaywallCoordinator = Coordinator & SheetActions

    @Published private var state: State = .loading
    @Published var user: DeferredData<User>
    @AppStorage(UserDefaults.Key.lastSubscriptionPurchaseDate.rawValue) private var lastSubscriptionPurchaseDate: Double?

    var utility: Utility {
        .init(state: state, user: user, lastSubscriptionPurchaseDate: lastSubscriptionPurchaseDate)
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

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
    }

    @MainActor
    func onSubscribeButtonTapped() async {
        guard let selectedProduct = utility.selectedProduct,
              let subscriptionId = user.currentValue?.subscriptionId else { return }
        do {
            if utility.trialAvailable {
                try await coordinator.dependencies.cloudRepository.startTrial(.init())
                ToastView.showSuccess(message: "Your 7-day trial period has begun. Enjoy full access to all features.")
            } else {
                _ = try await coordinator.dependencies.storeKitRepository.purchase(selectedProduct, with: [.appAccountToken(subscriptionId)])
                self.lastSubscriptionPurchaseDate = Date.now.timeIntervalSince1970
                ToastView.showSuccess(message: "Thank you for subscribing! Your subscription will be activated shortly.")
            }
            coordinator.dismissSheet()
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

    func onPrivacyPolicyTapped() {
        guard let urlString = coordinator.dependencies.configurationRepository.getValue(for: .privacyPolicyUrl).stringValue,
              let url = URL(string: urlString) else {
            return
        }
        NSWorkspace.shared.open(url)
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
