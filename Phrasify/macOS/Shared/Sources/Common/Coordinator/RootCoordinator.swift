//
//  RootCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI
import Domain

final class RootCoordinator: ObservableObject, Coordinator {

    @Published private(set) var updateInfo: AppUpdateHandler.UpdateInfo?
    @Published private(set) var isLoggedIn: Bool?

    var dependencies: Dependencies

    private let appUpdateHandler: AppUpdateHandler

    init() {
        let authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
        let firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()
        let cloudRepository: CloudRepository = CloudRepositoryImpl()
        let storageRepository: StorageRepository = StorageRepositoryImpl()
        let storeKitRepository: StoreKitRepository = StoreKitRepositoryImpl()
        let userDomain: UserDomain = .init(firestoreRepository: firestoreRepository, authenticationRepository: authenticationRepository)
        let searchRepository: SearchRepository = SearchRepositoryImpl()
        let configurationRepository: ConfigurationRepository = ConfigurationRepositoryImpl()
        let localizationSyncRepository: LocalizationSyncRepository = LocalizationSyncRepositoryImpl()
        dependencies = .init(authenticationRepository: authenticationRepository,
                             firestoreRepository: firestoreRepository,
                             cloudRepository: cloudRepository,
                             storageRepository: storageRepository,
                             storeKitRepository: storeKitRepository,
                             userDomain: userDomain,
                             searchRepository: searchRepository,
                             configurationRepository: configurationRepository,
                             localizationSyncRepository: localizationSyncRepository)
        appUpdateHandler = .init(configurationRepository: configurationRepository)
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        dependencies.authenticationRepository.isLoggedInPublisher
            .assign(to: &$isLoggedIn)
        appUpdateHandler.$updateInfo
            .assign(to: &$updateInfo)
    }
}
