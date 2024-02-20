//
//  MockDependencies.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation

struct MockDependencies {

    static let dependencies: Dependencies = .init(authenticationRepository: MockAuthenticationRepository(), 
                                                  firestoreRepository: MockFirestoreRepository(),
                                                  cloudRepository: MockCloudRepository(),
                                                  storageRepository: MockStorageRepository(),
                                                  storeKitRepository: MockStoreKitRepository(),
                                                  userDomain: .init(firestoreRepository: MockFirestoreRepository(),
                                                                    authenticationRepository: MockAuthenticationRepository()),
                                                  searchRepository: MockSearchRepository(),
                                                  configurationRepository: MockConfigurationRepository())

    func makeDependencies(authenticationRepository: MockAuthenticationRepository = MockAuthenticationRepository(),
                          firestoreRepository: MockFirestoreRepository = MockFirestoreRepository(),
                          cloudRepository: MockCloudRepository = MockCloudRepository(),
                          storageRepository: MockStorageRepository = MockStorageRepository(),
                          storeKitRepository: MockStoreKitRepository = MockStoreKitRepository(),
                          userDomain: UserDomain = UserDomain(firestoreRepository: MockFirestoreRepository(), 
                                                              authenticationRepository: MockAuthenticationRepository()),
                          searchRepository: MockSearchRepository = MockSearchRepository(),
                          configurationRepository: MockConfigurationRepository = MockConfigurationRepository()) -> Dependencies {
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
