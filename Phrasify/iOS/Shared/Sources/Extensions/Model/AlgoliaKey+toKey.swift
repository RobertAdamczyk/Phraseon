//
//  AlgoliaKey+toKey.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 11.02.24.
//

import Foundation
import Model

extension AlgoliaKey {

    var toKey: Key {
        .init(id: self.keyId,
              translation: self.translation,
              createdAt: .init(timeIntervalSince1970: TimeInterval(self.createdAt.seconds)),
              lastUpdatedAt: .init(timeIntervalSince1970: TimeInterval(self.lastUpdatedAt.seconds)),
              status: self.status)
    }
}
