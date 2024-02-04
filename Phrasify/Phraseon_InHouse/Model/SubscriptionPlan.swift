//
//  SubscriptionPlan.swift
//  Phraseon_InHouse
//
//  Created by Robert Adamczyk on 04.02.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case individual = "robert.adamczyk.phraseon.inhouse.subscription.plan.individual"
    case team = "robert.adamczyk.phraseon.inhouse.subscription.plan.team"

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
