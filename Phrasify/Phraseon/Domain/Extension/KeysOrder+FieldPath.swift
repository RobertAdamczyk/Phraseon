//
//  KeysOrder+FieldPath.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import Foundation
import FirebaseFirestore

extension KeysOrder {

    var value: (field: FieldPath, descending: Bool) {
        switch self {
        case .alphabetically: return (field: FieldPath.documentID(), descending: false)
        case .recent: return (field: FieldPath.init([Key.CodingKeys.lastUpdatedAt.rawValue]), descending: true)
        case .alert: return (field: FieldPath.init([Key.CodingKeys.status.rawValue]), descending: true)
        }
    }
}
