//
//  SubscriptionPlan.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.01.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case individual = "robert.adamczyk.phrasify.inhouse.subscription.individual"
    case team = "robert.adamczyk.phrasify.inhouse.subscription.team"

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
