//
//  RootCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject, Coordinator {

    @Published var navigationViews: [NavigationView] = []

    var isLoggedIn: Bool? { dependencies.authenticationRepository.isLoggedIn }

    var dependencies: Dependencies

    private var cancelBag = CancelBag()

    init() {
        dependencies = .init(authenticationRepository: .init())
        setupLoginSubscription()
    }

    private func setupLoginSubscription() {
        dependencies.authenticationRepository.$isLoggedIn.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: cancelBag)
    }
}

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator: RootCoordinator = .init()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    NavigationStack(path: $rootCoordinator.navigationViews) {
                        HomeView(coordinator: rootCoordinator)
                    }
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(parentCoordinator: rootCoordinator)
                }
            }
        }
    }
}

extension RootCoordinator {

    enum NavigationView {
        case empty
    }
}
