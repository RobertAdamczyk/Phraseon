//
//  KeyStatus+UI.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

extension KeyStatus {

    var color: Color {
        switch self {
        case .approved: appColor(.paleOrange)
        case .review: appColor(.paleOrange)
        }
    }

    var image: Image {
        switch self {
        case .approved: Image(systemName: "checkmark")
        case .review: Image(systemName: "magnifyingglass")
        }
    }

    var localizedTitle: String {
        return switch self {
        case .approved: "Approved"
        case .review: "Review"
        }
    }
}
