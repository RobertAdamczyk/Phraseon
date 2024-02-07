//
//  HighlightResult.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct HighlightResult: Codable {
    let createdAt: HighlightTimestamp
    let keyId: Highlight
    let lastUpdatedAt: HighlightTimestamp
    let status: [String: Highlight]
    let translation: [String: Highlight]
}
