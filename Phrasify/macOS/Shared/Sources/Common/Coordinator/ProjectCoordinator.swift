//
//  ProjectCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI
import Model
import Domain

final class ProjectCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var navigationViews: [NavigationView] = []
    @Published var presentedSheet: Sheet?

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension ProjectCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension ProjectCoordinator: SheetActions {

    func dismissSheet() {
        presentedSheet = nil
    }
}

extension ProjectCoordinator: ProjectsActions {

    func showProjectDetail(project: Project) {
        let viewModel = ProjectDetailViewModel(coordinator: self, project: project)
        let view: NavigationView = .projectDetail(viewModel: viewModel)
        self.navigationViews.append(view)
    }

    func presentCreateProject() {
        presentedSheet = .createProject
    }
}

extension ProjectCoordinator: ProjectDetailActions {

    func showCreateKey(project: Project, context: CreateKeyViewModel.Context) {
        let viewModel = CreateKeyViewModel(coordinator: self, project: project, context: context)
        let sheet: Sheet = .createKey(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = KeyDetailViewModel(coordinator: self, key: key, project: project, projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .keyDetail(viewModel: viewModel)
        self.navigationViews.append(view)
    }

    func showDeleteKeyWarning(project: Project, key: Key) {
        let viewModel = DeleteKeyWarningViewModel(coordinator: self, project: project, key: key)
        let sheet: Sheet = .deleteKeyWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = ProjectSettingsViewModel(coordinator: self, projectUseCase: projectUseCase, projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .projectSettings(viewModel: viewModel)
        self.navigationViews.append(view)
    }

    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = ProjectMembersViewModel(coordinator: self, project: project, projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .projectMembers(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showLeaveProjectInformation() {
        let viewModel = LeaveProjectInformationViewModel(coordinator: self)
        let sheet: Sheet = .leaveProjectInformation(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showLeaveProjectWarning(project: Project) {
        let viewModel = LeaveProjectWarningViewModel(coordinator: self, project: project)
        let sheet: Sheet = .leaveProjectWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showDeleteProjectWarning(project: Project) {
        let viewModel = DeleteProjectWarningViewModel(coordinator: self, project: project)
        let sheet: Sheet = .deleteProjectWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }
}

extension ProjectCoordinator: SelectLanguageActions {
    func showSelectLanguage(name: String) {
    }
    
    func showSelectedLanguages(project: Project) {
        let viewModel = SelectLanguageViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedLanguages(viewModel: viewModel)
        self.navigationViews.append(view)
    }
    
    func showSelectBaseLanguage(name: String, languages: [Language]) {
    }
    
    func showSelectedBaseLanguage(project: Project) {
        let viewModel = SelectBaseLanguageViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectBaseLanguage(viewModel: viewModel)
        self.navigationViews.append(view)
    }
}

extension ProjectCoordinator: SelectTechnologyActions {
    func showSelectTechnology(name: String, languages: [Model.Language], baseLanguage: Model.Language) {
    }
    
    func showSelectedTechnologies(project: Project) {
        let viewModel = SelectTechnologyViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedTechnologies(viewModel: viewModel)
        self.navigationViews.append(view)
    }
}

extension ProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        static func == (lhs: ProjectCoordinator.NavigationView, rhs: ProjectCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        case projectDetail(viewModel: ProjectDetailViewModel)
        case keyDetail(viewModel: KeyDetailViewModel)
        case projectSettings(viewModel: ProjectSettingsViewModel)
        case selectedLanguages(viewModel: SelectLanguageViewModel)
        case selectBaseLanguage(viewModel: SelectBaseLanguageViewModel)
        case selectedTechnologies(viewModel: SelectTechnologyViewModel)
        case projectMembers(viewModel: ProjectMembersViewModel)

        var id: String {
            switch self {
            case .projectDetail: return "001"
            case .keyDetail: return "002"
            case .projectSettings: return "003"
            case .selectedLanguages: return "004"
            case .selectBaseLanguage: return "005"
            case .selectedTechnologies: return "006"
            case .projectMembers: return "007"
            }
        }
    }

    enum Sheet: Identifiable {
        case createProject
        case createKey(viewModel: CreateKeyViewModel)
        case deleteKeyWarning(viewModel: DeleteKeyWarningViewModel)
        case leaveProjectWarning(viewModel: LeaveProjectWarningViewModel)
        case leaveProjectInformation(viewModel: LeaveProjectInformationViewModel)
        case deleteProjectWarning(viewModel: DeleteProjectWarningViewModel)

        var id: String {
            switch self {
            case .createProject: return "001"
            case .createKey: return "002"
            case .deleteKeyWarning: return "003"
            case .leaveProjectWarning: return "004"
            case .leaveProjectInformation: return "005"
            case .deleteProjectWarning: return "006"
            }
        }
    }
}
