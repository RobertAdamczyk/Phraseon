//
//  ProjectSettingsViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 04.01.24.
//

import SwiftUI

final class ProjectSettingsViewModel: ObservableObject, ProjectMemberProtocol {

    typealias ProjectSettingsCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions & ProjectActions

    @Published var project: Project
    @Published internal var member: Member?

    var shouldLanguagesInteractive: Bool {
        isAdmin || isOwner
    }

    var shouldTechnologiesInteractive: Bool {
        isAdmin || isOwner
    }

    private let coordinator: ProjectSettingsCoordinator
    internal let projectMemberUseCase: ProjectMemberUseCase
    internal let cancelBag = CancelBag()

    init(coordinator: ProjectSettingsCoordinator, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        self.coordinator = coordinator
        self.project = project
        self.projectMemberUseCase = projectMemberUseCase
        setupProjectSubscriber()
        setupMemberSubscriber()
    }

    func onLanguagesTapped() {
        coordinator.showSelectedLanguages(project: project)
    }

    func onTechnologiesTapped() {
        coordinator.showSelectedTechnologies(project: project)
    }

    func onMembersTapped() {
        coordinator.showProjectMembers(project: project, projectMemberUseCase: projectMemberUseCase)
    }

    func onOwnerTapped() {
        coordinator.showChangeProjectOwner(project: project)
    }

    func onLeaveProjectTapped() {
        if project.owner == coordinator.dependencies.authenticationRepository.currentUser?.uid {
            coordinator.showLeaveProjectWarning(context: .owner)
        } else {
            coordinator.showLeaveProjectWarning(context: .notOwner)
        }
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

