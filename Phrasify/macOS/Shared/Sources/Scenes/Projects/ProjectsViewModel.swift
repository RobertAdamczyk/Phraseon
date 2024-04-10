//
//  ProjectsViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 25.03.24.
//

import SwiftUI
import Combine
import Model
import Common

final class ProjectsViewModel: ObservableObject {

    typealias ProjectsCoordinator = Coordinator & ProjectsActions

    @Published private(set) var projects: [Project] = []

    private let coordinator: ProjectsCoordinator

    private var cancelBag = CancelBag()

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.userId
    }

    init(coordinator: ProjectsCoordinator) {
        self.coordinator = coordinator
        setupProjectsSubscriber()
    }

    func onProjectTapped(project: Project) {
        coordinator.showProjectDetail(project: project)
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

