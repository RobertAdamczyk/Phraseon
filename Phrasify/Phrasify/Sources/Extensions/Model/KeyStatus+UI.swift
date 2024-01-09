//
//  KeyStatus+UI.swift
//  Phrasify
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
