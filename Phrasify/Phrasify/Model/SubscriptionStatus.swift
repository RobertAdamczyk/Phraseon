//
//  SubscriptionStatus.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation

enum SubscriptionStatus: String, Codable, CaseIterable {

    case trial = "TRIAL"
    case basic = "BASIC"
    case gold = "GOLD"
}

extension SubscriptionStatus {

    static var buyable: [SubscriptionStatus] {
        SubscriptionStatus.allCases.filter { $0 != .trial }
    }
}
