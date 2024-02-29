//
//  MockDependencies.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation

struct MockDependencies {

    static let dependencies: Dependencies = .init(authenticationRepository: PreviewAuthenticationRepository(), 
                                                  firestoreRepository: PreviewFirestoreRepository(),
                                                  cloudRepository: PreviewCloudRepository(),
                                                  storageRepository: PreviewStorageRepository(),
                                                  storeKitRepository: PreviewStoreKitRepository(),
                                                  userDomain: .init(firestoreRepository: PreviewFirestoreRepository(),
                                                                    authenticationRepository: PreviewAuthenticationRepository()),
                                                  searchRepository: PreviewSearchRepository(),
                                                  configurationRepository: PreviewConfigurationRepository())

    static func makeDependencies(authenticationRepository: AuthenticationRepository = PreviewAuthenticationRepository(),
                                 firestoreRepository: FirestoreRepository = PreviewFirestoreRepository(),
                                 cloudRepository: CloudRepository = PreviewCloudRepository(),
                                 storageRepository: StorageRepository = PreviewStorageRepository(),
                                 storeKitRepository: StoreKitRepository = PreviewStoreKitRepository(),
                                 userDomain: UserDomain = UserDomain(firestoreRepository: PreviewFirestoreRepository(),
                                                                     authenticationRepository: PreviewAuthenticationRepository()),
                                 searchRepository: SearchRepository = PreviewSearchRepository(),
                                 configurationRepository: ConfigurationRepository = PreviewConfigurationRepository()) -> Dependencies {
        return .init(authenticationRepository: authenticationRepository,
                     firestoreRepository: firestoreRepository,
                     cloudRepository: cloudRepository,
                     storageRepository: storageRepository,
                     storeKitRepository: storeKitRepository,
                     userDomain: userDomain,
                     searchRepository: searchRepository,
                     configurationRepository: configurationRepository)
    }
}
