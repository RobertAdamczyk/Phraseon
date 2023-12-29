//
//  KeysOrder+UI.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import Foundation

extension KeysOrder {

    var title: String {
        switch self {
        case .alphabetically: return "A-Z"
        case .recent: return "Recent"
        case .alert: return "Alert"
        }
    }
}
