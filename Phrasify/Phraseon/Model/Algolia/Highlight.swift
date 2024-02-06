//
//  Highlight.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct Highlight: Codable {
    let value: String
    let matchLevel: String
    let matchedWords: [String]
}
