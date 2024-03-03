//
//  HighlightResult.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

public struct HighlightResult: Codable {
    public let keyId: Highlight
    public let translation: [String: Highlight]

    public init(keyId: Highlight, translation: [String : Highlight]) {
        self.keyId = keyId
        self.translation = translation
    }
}
