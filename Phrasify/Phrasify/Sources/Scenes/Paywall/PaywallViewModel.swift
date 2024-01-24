//
//  PaywallViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI

final class PaywallViewModel: ObservableObject {

    typealias PaywallCoordinator = Coordinator

    @Published var selectedSubscriptionPlan: SubscriptionStatus = .basic

    private let coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func onPlanTapped(_ plan: SubscriptionStatus) {
        withAnimation {
            selectedSubscriptionPlan = plan
        }
    }

    func getInfo(for status: SubscriptionStatus) -> (headline: String, price: String) {
        switch status {
        case .trial: fatalError("Don't use that.")
        case .basic: return ("Basic", "$9.99")
        case .gold: return ("Gold", "$29.99")
        }
    }

    func getPlan(for status: SubscriptionStatus) -> [String] {
        switch status {
        case .trial:
            fatalError("Don't use that.")
        case .basic:
            ["Reliable customer support.", "Includes all Basic features.", "Single-user access only.", "Ideal for freelancers and small projects."]
        case .gold:
            ["Reliable customer support.", "Includes all features.", "Add multiple members to projects.", "Perfect for teams and collaboration."]
        }
    }
}
