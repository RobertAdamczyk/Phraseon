//
//  AlgoliaKey.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

public struct AlgoliaKey: Codable {
    public let createdAt: AlgoliaTimestamp
    public let lastUpdatedAt: AlgoliaTimestamp
    public let status: [String: KeyStatus]
    public let translation: Translation
    public let keyId: String
    public let projectId: String
    public let objectID: String
    public let highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case createdAt, lastUpdatedAt, status, translation, objectID, keyId, projectId
        case highlightResult = "_highlightResult"
    }

    public init(createdAt: AlgoliaTimestamp,
                lastUpdatedAt: AlgoliaTimestamp,
                status: [String : KeyStatus],
                translation: Translation,
                keyId: String,
                projectId: String,
                objectID: String,
                highlightResult: HighlightResult) {
        self.createdAt = createdAt
        self.lastUpdatedAt = lastUpdatedAt
        self.status = status
        self.translation = translation
        self.keyId = keyId
        self.projectId = projectId
        self.objectID = objectID
        self.highlightResult = highlightResult
    }
}
