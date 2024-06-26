//
//  Dependencies.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation
import Domain

struct Dependencies {
    let authenticationRepository: AuthenticationRepository
    let firestoreRepository: FirestoreRepository
    let cloudRepository: CloudRepository
    let storageRepository: StorageRepository
    let storeKitRepository: StoreKitRepository
    let userDomain: UserDomain
    let searchRepository: SearchRepository
    let configurationRepository: ConfigurationRepository
    let localizationSyncRepository: LocalizationSyncRepository
}
