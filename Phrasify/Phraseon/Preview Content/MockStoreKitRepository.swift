//
//  MockStoreKitRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import StoreKit

final class MockStoreKitRepository: StoreKitRepository {

    func getProducts() async throws -> [Product] {
        return []
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return .detached {
            print("")
        }
    }
}
