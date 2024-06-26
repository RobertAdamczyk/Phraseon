//
//  Technology+UI.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import Foundation
import Model

extension Technology {

    var title: String {
        switch self {
        case .swift: "Swift"
        case .kotlin: "Kotlin"
        }
    }
}

extension Array where Element == Technology {

    var joined: String {
        self.compactMap { $0.title }.joined(separator: "/")
    }
}
