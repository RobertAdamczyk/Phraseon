//
//  Technology.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation

enum Technology: String, CaseIterable, Codable {
    case swift = "SWIFT"
    case kotlin = "KOTLIN"
}

extension Technology {

    var title: String {
        switch self {
        case .swift: "Swift"
        case .kotlin: "Kotlin"
        }
    }
}
