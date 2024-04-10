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
    func presentCreateKey(project: Project) {
    }
    
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) {
    }
    
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
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

        var id: String {
            switch self {
            case .projectDetail: return "001"
            }
        }
    }

    enum Sheet: Identifiable {
        case createProject

        var id: String {
            switch self {
            case .createProject: return "001"
            }
        }
    }
}
