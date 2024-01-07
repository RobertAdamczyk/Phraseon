//
//  Role+UI.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import Foundation

extension Role {

    var title: String {
        switch self {
        case .owner: return "Owner"
        case .viewer: return "Viewer"
        case .developer: return "Developer"
        case .admin: return "Admin"
        }
    }

    var sectionTitle: String {
        switch self {
        case .owner: return "Owner"
        case .viewer: return "Viewers"
        case .developer: return "Developers"
        case .admin: return "Admins"
        }
    }
}
