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

    case basic = "BASIC"
    case gold = "GOLD"

    var skuId: String {
        switch self {
        case .basic: return "robert.adamczyk.phrasify.inhouse.subscription.basic"
        case .gold: return "robert.adamczyk.phrasify.inhouse.subscription.gold"
        }
    }

    var title: String {
        switch self {
        case .basic: return "Basic"
        case .gold: return "Gold"
        }
    }
}
