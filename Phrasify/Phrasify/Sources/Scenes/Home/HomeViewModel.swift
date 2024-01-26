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

    private var cancelBag = CancelBag()

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.currentUser?.uid
    }

    private lazy var syncSubscriptionUseCase: SyncSubscriptionUseCase = {
        .init(firestoreRepository: coordinator.dependencies.firestoreRepository,
              glassfyRepository: coordinator.dependencies.glassfyRepository,
              authenticationRepository: coordinator.dependencies.authenticationRepository)
    }()

    @MainActor
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        setupProjectsSubscriber()
        syncSubscriptionUseCase.sync()
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

    @MainActor
    private func setupProjectsSubscriber() {
        guard let userId else { return }
        coordinator.dependencies.firestoreRepository.getProjectsPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] projects in
                self?.projects = projects
            }
            .store(in: cancelBag)
    }
}
