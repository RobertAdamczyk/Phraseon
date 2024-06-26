//
//  MockDependencies.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import Domain

struct MockDependencies {

    static let dependencies: Dependencies = .init(authenticationRepository: PreviewAuthenticationRepository(), 
                                                  firestoreRepository: PreviewFirestoreRepository(),
                                                  cloudRepository: PreviewCloudRepository(),
                                                  storageRepository: PreviewStorageRepository(),
                                                  storeKitRepository: PreviewStoreKitRepository(),
                                                  userDomain: .init(firestoreRepository: PreviewFirestoreRepository(),
                                                                    authenticationRepository: PreviewAuthenticationRepository()),
                                                  searchRepository: PreviewSearchRepository(),
                                                  configurationRepository: PreviewConfigurationRepository(),
                                                  localizationSyncRepository: PreviewLocalizationSyncRepository())

    static func makeDependencies(authenticationRepository: AuthenticationRepository = PreviewAuthenticationRepository(),
                                 firestoreRepository: FirestoreRepository = PreviewFirestoreRepository(),
                                 cloudRepository: CloudRepository = PreviewCloudRepository(),
                                 storageRepository: StorageRepository = PreviewStorageRepository(),
                                 storeKitRepository: StoreKitRepository = PreviewStoreKitRepository(),
                                 searchRepository: SearchRepository = PreviewSearchRepository(),
                                 configurationRepository: ConfigurationRepository = PreviewConfigurationRepository(),
                                 localizationSyncRepository: LocalizationSyncRepository = PreviewLocalizationSyncRepository()) -> Dependencies {
        return .init(authenticationRepository: authenticationRepository,
                     firestoreRepository: firestoreRepository,
                     cloudRepository: cloudRepository,
                     storageRepository: storageRepository,
                     storeKitRepository: storeKitRepository,
                     userDomain: .init(firestoreRepository: firestoreRepository, authenticationRepository: authenticationRepository),
                     searchRepository: searchRepository,
                     configurationRepository: configurationRepository,
                     localizationSyncRepository: localizationSyncRepository)
    }
}
