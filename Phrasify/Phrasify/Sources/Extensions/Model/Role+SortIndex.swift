//
//  Role+SortIndex.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import Foundation

extension Role {

    var sortIndex: Int {
        switch self {
        case .owner: return 0
        case .admin: return 1
        case .developer: return 2
        case .viewer: return 3
        }
    }
}
