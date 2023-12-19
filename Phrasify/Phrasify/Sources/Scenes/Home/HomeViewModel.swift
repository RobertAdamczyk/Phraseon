//
//  HomeViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

final class HomeViewModel: ObservableObject {

    typealias HomeCoordinator = Coordinator & RootActions

    private let coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func testLogout() {
        try? coordinator.dependencies.authenticationRepository.logout()
    }

    func onProfileTapped() {
        coordinator.showProfile()
    }

    func onProjectTapped() {
        coordinator.showProjectDetails()
    }

    func onAddProjectTapped() {
        coordinator.showNewProject()
    }
}
