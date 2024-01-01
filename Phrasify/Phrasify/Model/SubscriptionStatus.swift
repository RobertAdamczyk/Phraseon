//
//  SubscriptionStatus.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation

enum SubscriptionStatus: String, Codable {

    case trial = "TRIAL"
    case basic = "BASIC"
    case gold = "GOLD"
}
