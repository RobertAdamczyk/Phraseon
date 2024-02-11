//
//  KeyStatus+UI.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

extension KeyStatus {

    var localizedTitle: String {
        return switch self {
        case .approved: "Approved"
        case .review: "In Review"
        }
    }
}

extension Key {

    var keyStatus: KeyStatus {
        self.status.values.contains(where: { $0 == KeyStatus.review}) ? KeyStatus.review : KeyStatus.approved
    }
}

extension AlgoliaKey {

    var keyStatus: KeyStatus {
        self.status.values.contains(where: { $0 == KeyStatus.review}) ? KeyStatus.review : KeyStatus.approved
    }
}
