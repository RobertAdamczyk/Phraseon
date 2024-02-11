//
//  Key.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.12.23.
//

import Foundation
import FirebaseFirestoreSwift

typealias Translation = [String: String]
typealias Status = [String: KeyStatus]

struct Key: Codable, Hashable {

    @DocumentID var id: String?
    var translation: Translation
    var createdAt: Date
    var lastUpdatedAt: Date
    var status: Status

    enum CodingKeys: String, CodingKey {
        case id
        case translation
        case createdAt
        case lastUpdatedAt
        case status
    }
}
