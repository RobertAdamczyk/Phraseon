//
//  HighlightTimestamp.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct HighlightTimestamp: Codable {
    let seconds: Highlight
    let nanoseconds: Highlight

    enum CodingKeys: String, CodingKey {
        case seconds = "_seconds"
        case nanoseconds = "_nanoseconds"
    }
}
