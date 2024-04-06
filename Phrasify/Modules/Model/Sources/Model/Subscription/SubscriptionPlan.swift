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
        case .monthly: return Self.currentMonthlyId
        case .yearly: return Self.currentYearlyId
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
        case Self.currentMonthlyId:
            self = .monthly
        case Self.currentYearlyId:
            self = .yearly
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown id")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.id)
    }

    private static var currentMonthlyId: String {
        return switch TargetConfiguration.shared.currentTarget {
        case .live: "robert.adamczyk.phraseon.live.subscription.plan.monthly"
        case .inHouse, .inHouseMacOS: "robert.adamczyk.phraseon.inhouse.subscription.plan.monthly"
        }
    }

    private static var currentYearlyId: String {
        return switch TargetConfiguration.shared.currentTarget {
        case .live: "robert.adamczyk.phraseon.live.subscription.plan.yearly"
        case .inHouse, .inHouseMacOS: "robert.adamczyk.phraseon.inhouse.subscription.plan.yearly"
        }
    }
}
