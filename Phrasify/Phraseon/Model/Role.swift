//
//  Role.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.12.23.
//

import Foundation

enum Role: String, Codable, Hashable, CaseIterable {

    case owner = "OWNER"
    case admin = "ADMIN"
    case developer = "DEVELOPER"
    case viewer = "VIEWER"
    case marketing = "MARKETING"
}
