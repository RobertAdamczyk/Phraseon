//
//  ProjectSettingsViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 14.04.24.
//

import SwiftUI
import Model
import Common
import Domain

final class ProjectSettingsViewModel: ObservableObject, ProjectMemberUseCaseProtocol, ProjectUseCaseProtocol {

    typealias ProjectSettingsCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions & ProjectDetailActions

    @Published internal var project: Project
    @Published internal var member: Member?

    var utility: Utility {
        .init(coordinator: coordinator)
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

    func onBaseLanguageTapped() {
        coordinator.showSelectedBaseLanguage(project: project)
    }

    func onIntegrationTapped() {
        // coordinator.showProjectIntegration(project: project)
    }

    func onTechnologiesTapped() {
        coordinator.showSelectedTechnologies(project: project)
    }

    func onMembersTapped() {
        coordinator.showProjectMembers(project: project, projectMemberUseCase: projectMemberUseCase)
    }

    func onOwnerTapped() {
        // coordinator.showChangeProjectOwner(project: project)
    }

    func onLeaveProjectTapped() {
//        if project.owner == coordinator.dependencies.authenticationRepository.userId {
//            coordinator.showLeaveProjectInformation()
//        } else {
//            coordinator.showLeaveProjectWarning(project: project)
//        }
    }

    func onDeleteProjectTapped() {
        // coordinator.showDeleteProjectWarning(project: project)
    }
}


