//
//  SubscriptionPlan.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.01.24.
//

import Foundation

enum SubscriptionPlan: String, Codable, CaseIterable {

    case basic = "robert.adamczyk.phrasify.inhouse.subscription.basic"
    case gold = "robert.adamczyk.phrasify.inhouse.subscription.gold"

    var id: String {
        self.rawValue
    }

    var sortIndex: Int {
        switch self {
        case .basic: return 0
        case .gold: return 1
        }
    }
}
