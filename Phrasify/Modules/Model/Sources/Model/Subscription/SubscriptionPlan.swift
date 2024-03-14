//
//  SubscriptionPlan.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.01.24.
//

import Foundation
import Common

public enum SubscriptionPlan: Codable, CaseIterable {

    case monthly
    case yearly

    public var id: String {
        switch self {
        case .monthly: return Self.monthlyId
        case .yearly: return Self.yearlyId
        }
    }

    public var sortIndex: Int {
        switch self {
        case .monthly: return 0
        case .yearly: return 1
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let id = try container.decode(String.self)

        switch id {
        case Self.monthlyId:
            self = .monthly
        case Self.yearlyId:
            self = .yearly
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Nieznane id")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.id)
    }

    private static var monthlyId: String {
        return switch TargetConfiguration.shared.currentTarget {
        case .live: "robert.adamczyk.phraseon.live.subscription.plan.monthly"
        case .inHouse: "robert.adamczyk.phraseon.inhouse.subscription.plan.monthly"
        case .inHouseMacOS: "none"
        }
    }

    private static var yearlyId: String {
        return switch TargetConfiguration.shared.currentTarget {
        case .live: "robert.adamczyk.phraseon.live.subscription.plan.yearly"
        case .inHouse: "robert.adamczyk.phraseon.inhouse.subscription.plan.yearly"
        case .inHouseMacOS: "none"
        }
    }
}
