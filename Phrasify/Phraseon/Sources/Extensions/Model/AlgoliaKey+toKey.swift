//
//  AlgoliaKey+toKey.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 11.02.24.
//

import Foundation

extension AlgoliaKey {

    var toKey: Key {
        .init(id: self.objectID,
              translation: self.translation,
              createdAt: .init(timeIntervalSince1970: TimeInterval(self.createdAt.seconds)),
              lastUpdatedAt: .init(timeIntervalSince1970: TimeInterval(self.lastUpdatedAt.seconds)),
              status: self.status)
    }
}