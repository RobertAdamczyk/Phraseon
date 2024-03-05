//
//  User.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation
import FirebaseFirestoreSwift

public struct User: Codable, Hashable, IdentifiableUser {

    @DocumentID public var id: String?
    public var email: String?
    public var name: String?
    public var surname: String?
    public var createdAt: Date
    public var subscriptionId: UUID
    public var subscriptionStatus: SubscriptionStatus?
    public var subscriptionPlan: SubscriptionPlan?
    public var subscriptionValidUntil: Date?
    public var photoUrl: String?

    public enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case surname
        case createdAt
        case subscriptionId
        case subscriptionStatus
        case subscriptionPlan
        case subscriptionValidUntil
        case photoUrl
    }

    public init(id: String? = nil,
                email: String,
                name: String,
                surname: String,
                createdAt: Date,
                subscriptionId: UUID,
                subscriptionStatus: SubscriptionStatus? = nil,
                subscriptionPlan: SubscriptionPlan? = nil,
                subscriptionValidUntil: Date? = nil,
                photoUrl: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
        self.createdAt = createdAt
        self.subscriptionId = subscriptionId
        self.subscriptionStatus = subscriptionStatus
        self.subscriptionPlan = subscriptionPlan
        self.subscriptionValidUntil = subscriptionValidUntil
        self.photoUrl = photoUrl
    }
}
