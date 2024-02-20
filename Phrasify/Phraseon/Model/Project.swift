//
//  Project.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct Project: Codable, Hashable {

    @DocumentID var id: String?
    var name: String
    var technologies: [Technology]
    var languages: [Language]
    var baseLanguage: Language
    var members: [UserID]
    var owner: UserID
    var securedAlgoliaApiKey: String
    var createdAt: Date
    var algoliaIndexName: String

    enum CodingKeys: String, CodingKey {
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
}
