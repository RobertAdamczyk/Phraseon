//
//  ProjectSettingsViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 04.01.24.
//

import SwiftUI

final class ProjectSettingsViewModel: ObservableObject {

    typealias ProjectSettingsCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions & ProjectActions

    @Published var project: Project

    private let coordinator: ProjectSettingsCoordinator
    private let cancelBag = CancelBag()

    init(coordinator: ProjectSettingsCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupProjectSubscriber()
    }

    func onLanguagesTapped() {
        coordinator.showSelectedLanguages(project: project)
    }

    func onTechnologiesTapped() {
        coordinator.showSelectedTechnologies(project: project)
    }

    func onMembersTapped() {
        coordinator.showProjectMembers(project: project)
    }

    func onOwnerTapped() {

    }

    func onLeaveProjectTapped() {

    }

    func onDeleteProjectTapped() {

    }

    private func setupProjectSubscriber() {
        guard let projectId = project.id else { return }
        coordinator.dependencies.firestoreRepository.getProjectPublisher(projectId: projectId)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] project in
                guard let project else { return }
                DispatchQueue.main.async {
                    self?.project = project
                }
            })
            .store(in: cancelBag)
    }
}

