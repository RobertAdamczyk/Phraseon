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

    var id: String {
        self.rawValue
    }
}

