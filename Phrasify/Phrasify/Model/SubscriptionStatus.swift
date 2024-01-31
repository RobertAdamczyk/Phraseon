//
//  SubscriptionStatus.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation

enum SubscriptionStatus: String, Codable, CaseIterable {

    case expires = "EXPIRES"
    case renews = "RENEWS"
    case trial = "TRIAL"
}

