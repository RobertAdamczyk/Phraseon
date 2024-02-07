//
//  AlgoliaKey.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct AlgoliaKey: Codable {
    let createdAt: AlgoliaTimestamp
    let lastUpdatedAt: AlgoliaTimestamp
    let status: [String: KeyStatus]
    let translation: Translation
    let keyId: String
    let objectID: String
    let highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case createdAt, lastUpdatedAt, status, translation, objectID, keyId
        case highlightResult = "_highlightResult"
    }
}
