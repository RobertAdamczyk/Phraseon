//
//  ContentView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 12.03.24.
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
        dependencies = .init(authenticationRepository: authenticationRepository,
                             firestoreRepository: firestoreRepository,
                             cloudRepository: cloudRepository,
                             storageRepository: storageRepository,
                             storeKitRepository: storeKitRepository,
                             userDomain: userDomain,
                             searchRepository: searchRepository,
                             configurationRepository: configurationRepository)
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

final class StartCoordinator: ObservableObject, Coordinator {

    typealias ParentCoordinator = Coordinator

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }

    struct RootView: View {

        @StateObject private var startCoordinator: StartCoordinator

        init(coordinator: StartCoordinator.ParentCoordinator) {
            self._startCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
        }

        var body: some View {
            Text("LOGIN")
        }
    }
}

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator = RootCoordinator()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    Text("HOME")
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(coordinator: rootCoordinator)
                }
            }
        }
    }
}

enum Tab {

    case home
    case user
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var strings: [String] = []
    @State private var presented: Bool = false

    var body: some View {
        NavigationSplitView {
            VStack {
                Text("Menu")
                    .apply(.bold, size: .H1, color: .white)
                Button {
                    selectedTab = .home
                } label: {
                    Text("HOME")
                }
                Button {
                    selectedTab = .user
                } label: {
                    Text("USER")
                }
            }
        } detail: {
            NavigationStack(path: $strings) {
                Group {
                    switch selectedTab {
                    case .home: 
                        home
                    case .user:
                        Text("USER")
                    }
                }


            }
        }
    }

    @State private var searchText: String = ""

    private var home: some View {
        ScrollView {
            VStack {
                Button {
                    strings.append("ONLY TEST")
                } label: {
                    Text("PUSH")
                }
                ForEach(0..<100) { _ in
                    Rectangle()
                        .frame(height: 20)
                }
                Button {
                    presented.toggle()
                } label: {
                    Text("PRESENT")
                }
            }
            .scenePadding()
        }
        .searchable(text: $searchText)
        .navigationTitle("title")
        .navigationSubtitle("subtitle")
        .navigationDestination(for: String.self) { string in
            Text(string)
                .navigationTitle(string)
        }
    }
}

#Preview {
    ContentView()
}
