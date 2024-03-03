//
//  Key.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.12.23.
//

import Foundation
import FirebaseFirestoreSwift

public typealias Translation = [String: String]
public typealias Status = [String: KeyStatus]

public struct Key: Codable, Hashable {

    @DocumentID public var id: String?
    public var translation: Translation
    public var createdAt: Date
    public var lastUpdatedAt: Date
    public var status: Status

    public enum CodingKeys: String, CodingKey {
        case id
        case translation
        case createdAt
        case lastUpdatedAt
        case status
    }

    public init(id: String? = nil, translation: Translation, createdAt: Date, lastUpdatedAt: Date, status: Status) {
        self.id = id
        self.translation = translation
        self.createdAt = createdAt
        self.lastUpdatedAt = lastUpdatedAt
        self.status = status
    }
}
