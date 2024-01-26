//
//  SubscriptionStatus.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation

enum SubscriptionStatus: String, Codable, CaseIterable {

    case trial = "TRIAL"
    case premium = "PREMIUM"
}

enum SubscriptionPlan: String, Codable, CaseIterable {

    case basic = "robert.adamczyk.phrasify.inhouse.subscription.basic"
    case gold = "robert.adamczyk.phrasify.inhouse.subscription.gold"

    var skuId: String {
        self.rawValue
    }

    var title: String {
        switch self {
        case .basic: return "Basic"
        case .gold: return "Gold"
        }
    }

    var sortIndex: Int {
        switch self {
        case .basic: return 0
        case .gold: return 1
        }
    }
}

