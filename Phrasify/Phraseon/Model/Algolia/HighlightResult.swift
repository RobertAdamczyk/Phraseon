//
//  HighlightResult.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct HighlightResult: Codable {
    let keyId: Highlight
    let translation: [String: Highlight]
}
