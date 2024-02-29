//
//  SubscriptionPlan.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.01.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case monthly = "robert.adamczyk.phraseon.live.subscription.plan.monthly"
    case yearly = "robert.adamczyk.phraseon.live.subscription.plan.yearly"

    var id: String {
        self.rawValue
    }

    var sortIndex: Int {
        switch self {
        case .monthly: return 0
        case .yearly: return 1
        }
    }
}
