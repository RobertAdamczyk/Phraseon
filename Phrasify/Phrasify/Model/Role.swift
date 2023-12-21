//
//  Role.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import Foundation

enum Role: String, Codable, Hashable {

    case owner = "OWNER"
    case viewer = "VIEWER"
    case developer = "DEVELOPER"
    case admin = "ADMIN"
}
