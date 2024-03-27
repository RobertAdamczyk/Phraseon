//
//  MenuItem+UI.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

extension MenuItem {

    var label: String {
        switch self {
        case .projects: return "Projects"
        case .profile: return "Profile"
        }
    }

    var systemImage: Image {
        switch self {
        case .projects: return .init(systemName: "house")
        case .profile: return .init(systemName: "person")
        }
    }
}
