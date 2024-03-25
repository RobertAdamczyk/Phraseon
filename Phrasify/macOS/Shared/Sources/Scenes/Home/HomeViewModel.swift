//
//  HomeViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 25.03.24.
//

import SwiftUI
import Combine
import Model
import Common

final class HomeViewModel: ObservableObject {

    typealias HomeCoordinator = Coordinator

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

    func onProjectTapped(project: Project) {
        // coordinator.showProjectDetails(project: project)
    }

    func onAddProjectTapped() {
        try? coordinator.dependencies.authenticationRepository.logout()
        // coordinator.presentCreateProject()
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

