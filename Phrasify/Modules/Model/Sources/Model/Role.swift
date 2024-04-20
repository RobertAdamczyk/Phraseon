//
//  Role.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.12.23.
//

import Foundation

public enum Role: String, Codable, Hashable, CaseIterable {

    case owner = "OWNER"
    case admin = "ADMIN"
    case developer = "DEVELOPER"
    case viewer = "VIEWER"
    case marketing = "MARKETING"

    public var sortIndex: Int {
        switch self {
        case .owner: return 0
        case .admin: return 1
        case .developer: return 2
        case .marketing: return 3
        case .viewer: return 4
        }
    }
}
