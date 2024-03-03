//
//  Highlight.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation
import AlgoliaSearchClient

public struct Highlight: Codable {
    public let value: HighlightedString
    public let matchLevel: MatchLevel
    public let matchedWords: [String]

    public init(value: HighlightedString, matchLevel: MatchLevel, matchedWords: [String]) {
        self.value = value
        self.matchLevel = matchLevel
        self.matchedWords = matchedWords
    }
}
