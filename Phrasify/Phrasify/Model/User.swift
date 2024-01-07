//
//  User.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 31.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Hashable {

    @DocumentID var id: String?
    var email: String
    var name: String
    var surname: String
    var createdAt: Date
    var subscriptionStatus: SubscriptionStatus
    var subscriptionValidUntil: Date
    var photoUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case surname
        case createdAt
        case subscriptionStatus
        case subscriptionValidUntil
        case photoUrl
    }
}
