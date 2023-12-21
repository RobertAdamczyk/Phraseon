//
//  HomeViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {

    typealias HomeCoordinator = Coordinator & RootActions

    @Published private(set) var projects: [Project] = []

    private let coordinator: HomeCoordinator

    private var cancelBag = Set<AnyCancellable>()

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.currentUser?.uid
    }

    @MainActor
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        setupProjectsSubscriber()
    }

    func onProfileTapped() {
        //coordinator.showProfile()
        try? coordinator.dependencies.authenticationRepository.logout()
    }

    func onProjectTapped(project: Project) {
        coordinator.showProjectDetails(project: project)
    }

    func onAddProjectTapped() {
        coordinator.presentCreateProject()
    }

    @MainActor
    private func setupProjectsSubscriber() {
        guard let userId else { return }
        coordinator.dependencies.firestoreRepository.getProjectsPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] projects in
                self?.projects = projects
            })
            .store(in: &cancelBag)
    }
}
