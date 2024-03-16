//
//  URLCache+ImageCache.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000,
                                     diskCapacity: 10*1000*1000*1000)
}
