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
}
