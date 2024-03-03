//
//  Project.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.12.23.
//

import Foundation
import FirebaseFirestoreSwift

public struct Project: Codable, Hashable {

    @DocumentID public var id: String?
    public var name: String
    public var technologies: [Technology]
    public var languages: [Language]
    public var baseLanguage: Language
    public var members: [UserID]
    public var owner: UserID
    public var securedAlgoliaApiKey: String
    public var createdAt: Date
    public var algoliaIndexName: String

    public enum CodingKeys: String, CodingKey {
        case id
        case name
        case technologies
        case languages
        case baseLanguage
        case members
        case owner
        case securedAlgoliaApiKey
        case createdAt
        case algoliaIndexName
    }

    public init(id: String? = nil,
                name: String,
                technologies: [Technology],
                languages: [Language],
                baseLanguage: Language,
                members: [UserID],
                owner: UserID,
                securedAlgoliaApiKey: String,
                createdAt: Date,
                algoliaIndexName: String) {
        self.id = id
        self.name = name
        self.technologies = technologies
        self.languages = languages
        self.baseLanguage = baseLanguage
        self.members = members
        self.owner = owner
        self.securedAlgoliaApiKey = securedAlgoliaApiKey
        self.createdAt = createdAt
        self.algoliaIndexName = algoliaIndexName
    }
}
