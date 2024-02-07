//
//  Highlight.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation
import AlgoliaSearchClient

struct Highlight: Codable {
    let value: AlgoliaSearchClient.HighlightedString
    let matchLevel: AlgoliaSearchClient.MatchLevel
    let matchedWords: [String]
}
