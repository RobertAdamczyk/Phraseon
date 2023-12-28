//
//  Key.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Key: Codable, Hashable {

    @DocumentID var id: String?
    var translation: [String: String]
    var createdAt: Date
    var lastUpdatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case translation
        case createdAt
        case lastUpdatedAt
    }
}
