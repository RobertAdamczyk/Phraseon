//
//  ProjectSettingsViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 04.01.24.
//

import SwiftUI

final class ProjectSettingsViewModel: ObservableObject, ProjectMemberUseCaseProtocol, ProjectUseCaseProtocol {

    typealias ProjectSettingsCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions & ProjectActions

    @Published internal var project: Project
    @Published internal var member: Member?

    var shouldLanguagesInteractive: Bool {
        isAdmin || isOwner
    }

    var shouldTechnologiesInteractive: Bool {
        isAdmin || isOwner
    }

    private let coordinator: ProjectSettingsCoordinator
    internal let projectMemberUseCase: ProjectMemberUseCase
    internal let projectUseCase: ProjectUseCase
    internal let cancelBag = CancelBag()

    init(coordinator: ProjectSettingsCoordinator, projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) {
        self.coordinator = coordinator
        self.projectUseCase = projectUseCase
        self.projectMemberUseCase = projectMemberUseCase
        self.project = projectUseCase.project
        setupProjectSubscriber()
        setupMemberSubscriber()
    }

    func onLanguagesTapped() {
        coordinator.showSelectedLanguages(project: project)
    }

    func onIntegrationTapped() {

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
        coordinator.showLeaveProjectWarning(project: project)
    }

    func onDeleteProjectTapped() {
        coordinator.showDeleteProjectWarning(project: project)
    }
}

