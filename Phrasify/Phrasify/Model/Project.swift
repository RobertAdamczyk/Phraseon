//
//  Project.swift
//  Phrasify
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
    var members: [UserID]
    var owner: UserID

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case technologies
        case languages
        case members
        case owner
    }
}
