//
//  PaywallViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI
import Glassfy

final class PaywallViewModel: ObservableObject {

    enum State {
        case loading
        case error
        case idle([Glassfy.Sku], SubscriptionPlan)
    }

    typealias PaywallCoordinator = Coordinator & FullScreenCoverActions

    @Published var state: State = .loading

    var selectedSubscriptionPlan: SubscriptionPlan? {
        if case .idle(_, let subscriptionPlan) = state {
            return subscriptionPlan
        }
        return nil
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    private var selectedSku: Glassfy.Sku? {
        if case .idle(let skus, let subscriptionPlan) = state {
            return skus.first { $0.product.productIdentifier == subscriptionPlan.skuId }
        }
        return nil
    }

    private let coordinator: PaywallCoordinator
    private lazy var syncSubscriptionUseCase: SyncSubscriptionUseCase = {
        .init(firestoreRepository: coordinator.dependencies.firestoreRepository,
              glassfyRepository: coordinator.dependencies.glassfyRepository,
              authenticationRepository: coordinator.dependencies.authenticationRepository)
    }()

    init(coordinator: PaywallCoordinator) {
        self.coordinator = coordinator
        getSkus()
    }

    func onPlanTapped(_ plan: SubscriptionPlan) {
        withAnimation {
            if case .idle(let skus, _) = state {
                self.state = .idle(skus, plan)
            }
        }
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    @MainActor
    func onRestorePurchaseButtonTapped() {
        Task {
            do {
                try await coordinator.dependencies.glassfyRepository.restorePurchase()
                syncSubscriptionUseCase.sync()
            } catch {
                ToastView.showGeneralError()
            }
        }
    }

    @MainActor
    func onSubscribeButtonTapped() async {
        guard let selectedSku else { return }
        do {
            _ = try await coordinator.dependencies.glassfyRepository.purchase(product: selectedSku)
            syncSubscriptionUseCase.sync()
        } catch {
            ToastView.showGeneralError()
        }
    }

    func getInfo(for plan: SubscriptionPlan) -> (headline: String, price: String) {
        let price: String = {
            if case .idle(let skus, _) = state {
                let product = skus.first { $0.product.productIdentifier == plan.skuId }?.product
                let currency = product?.priceLocale.currencySymbol
                let price = product?.price
                if let price, let currency {
                    return "\(currency)\(price)"
                }
                return "NaN"
            }
            return "NaN"
        }()
        return (plan.title, price)
    }

    private func getSkus() {
        Task {
            do {
                let skus = try await coordinator.dependencies.glassfyRepository.getOffers()
                await MainActor.run {
                    self.state = .idle(skus, .basic)
                }
            } catch {
                ToastView.showGeneralError()
            }
        }
    }
}

extension PaywallViewModel {

    var plans: [PlanDescription] {
        switch self.selectedSubscriptionPlan {
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
