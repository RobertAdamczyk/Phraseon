//
//  HomeViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI
import Combine
import Model
import Common

final class HomeViewModel: ObservableObject {

    typealias HomeCoordinator = Coordinator & RootActions

    @Published private(set) var projects: [Project] = []

    private let coordinator: HomeCoordinator

    private var cancelBag = CancelBag()

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.userId
    }

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        setupProjectsSubscriber()
    }

    func onProfileTapped() {
        coordinator.showProfile()
    }

    func onProjectTapped(project: Project) {
        coordinator.showProjectDetails(project: project)
    }

    func onAddProjectTapped() {
        coordinator.presentCreateProject()
    }

    private func setupProjectsSubscriber() {
        guard let userId else { return }
        coordinator.dependencies.firestoreRepository.getProjectsPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] projects in
                DispatchQueue.main.async { [weak self] in
                    self?.projects = projects
                }
            }
            .store(in: cancelBag)
    }
}
