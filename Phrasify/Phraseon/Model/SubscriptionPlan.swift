//
//  SubscriptionPlan.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.01.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case individual = "robert.adamczyk.phraseon.live.subscription.plan.individual"
    case team = "robert.adamczyk.phraseon.live.subscription.plan.team"

    var id: String {
        self.rawValue
    }

    var sortIndex: Int {
        switch self {
        case .individual: return 0
        case .team: return 1
        }
    }
}
