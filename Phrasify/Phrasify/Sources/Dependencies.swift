//
//  Dependencies.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation

struct Dependencies {
    let authenticationRepository: AuthenticationRepository
    let firestoreRepository: FirestoreRepository
    let cloudRepository: CloudRepository
    let storageRepository: StorageRepository
    let storeKitRepository: StoreKitRepository
}
