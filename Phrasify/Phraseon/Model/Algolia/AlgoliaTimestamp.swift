//
//  AlgoliaTimestamp.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation

struct AlgoliaTimestamp: Codable {
    let seconds: Int
    let nanoseconds: Int

    enum CodingKeys: String, CodingKey {
        case seconds = "_seconds"
        case nanoseconds = "_nanoseconds"
    }
}
