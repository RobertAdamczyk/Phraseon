//
//  PreviewStoreKitRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import StoreKit
import Domain

final class PreviewStoreKitRepository: StoreKitRepository {

    func getProducts() async throws -> [Product] {
        return []
    }
}
