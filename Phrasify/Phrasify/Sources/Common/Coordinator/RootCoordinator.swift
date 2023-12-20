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
    @Published var presentedFullScreenCover: FullScreenCover?

    var isLoggedIn: Bool? { dependencies.authenticationRepository.isLoggedIn }

    var dependencies: Dependencies

    private var cancelBag = CancelBag()

    init() {
        dependencies = .init(authenticationRepository: .init(), firestoreRepository: .init())
        setupLoginSubscription()
    }

    private func setupLoginSubscription() {
        dependencies.authenticationRepository.$isLoggedIn.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: cancelBag)
    }
}

extension RootCoordinator: RootActions {

    func showProfile() {
        navigationViews.append(.profile)
    }

    func presentNewProject() {
        presentedFullScreenCover = .newProject
    }

    func showProjectDetails() {
        navigationViews.append(.projectDetails)
    }

    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
}

extension RootCoordinator {

    enum NavigationView {
        case profile
        case projectDetails
    }

    enum FullScreenCover: String, Identifiable {
        case newProject

        var id: String { self.rawValue }
    }
}
