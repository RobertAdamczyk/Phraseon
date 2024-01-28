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

    @Published var state: State = .loading
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

//    var alreadyBoughtProduct: Product? {
//        if case .idle(let subscriptionInfo, _) = state {
//            let product: Product? = {
//                let plan = subscriptionInfo.permission.accountableSkus.compactMap { SubscriptionPlan(rawValue: $0.productId) }
//                return plan.sorted(by: { $0.sortIndex > $1.sortIndex }).first
//            }()
//            return subscriptionPlan
//        }
//        return nil
//    }
//
//    var alreadyBoughtUserEmail: String? {
//        if case .idle(let subscriptionInfo, _) = state {
//            return subscriptionInfo.userProperties.email
//        }
//        return nil
//    }

//    var hasValidSubscription: Bool {
//        if case .idle(let subscriptionInfo, _) = state {
//            return subscriptionInfo.permission.isValid
//        }
//        return false
//    }
//
//    private var selectedSku: Glassfy.Sku? {
//        if case .idle(let info, let subscriptionPlan) = state {
//            return info.skus.first { $0.product.productIdentifier == subscriptionPlan.skuId }
//        }
//        return nil
//    }

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
        withAnimation {
            if case .idle(let products, _) = state {
                self.state = .idle(products, product)
            }
        }
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    @MainActor
    func onSubscribeButtonTapped() async {
        guard let selectedProduct, let subscriptionId = user?.subscriptionId else { return }
        do {
            _ = try await coordinator.dependencies.storeKitRepository.purchase(selectedProduct, with: [.appAccountToken(subscriptionId)])
        } catch {
            ToastView.showGeneralError()
        }
    }

    private func getProducts() {
        Task {
            do {
                let products = try await coordinator.dependencies.storeKitRepository.getProducts()
                await MainActor.run {
                    if let basic = products.filter({ $0.id == SubscriptionPlan.basic.id}).first {
                        self.state = .idle(products, basic)
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
