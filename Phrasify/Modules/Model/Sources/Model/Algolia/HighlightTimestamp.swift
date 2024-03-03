//
//  HighlightTimestamp.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

public struct HighlightTimestamp: Codable {
    public let seconds: Highlight
    public let nanoseconds: Highlight

    enum CodingKeys: String, CodingKey {
        case seconds = "_seconds"
        case nanoseconds = "_nanoseconds"
    }

    public init(seconds: Highlight, nanoseconds: Highlight) {
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }
}
