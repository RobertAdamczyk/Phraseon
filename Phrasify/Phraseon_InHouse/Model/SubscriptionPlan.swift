//
//  SubscriptionPlan.swift
//  Phraseon_InHouse
//
//  Created by Robert Adamczyk on 04.02.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case yearly = "robert.adamczyk.phraseon.inhouse.subscription.plan.yearly"
    case monthly = "robert.adamczyk.phraseon.inhouse.subscription.plan.monthly"

    var id: String {
        self.rawValue
    }

    var sortIndex: Int {
        switch self {
        case .yearly: return 0
        case .monthly: return 1
        }
    }
}
