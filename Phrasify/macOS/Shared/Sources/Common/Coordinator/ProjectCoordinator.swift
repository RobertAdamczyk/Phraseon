//
//  ProjectCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI

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

    func showProjectDetail() {
        navigationViews.append(.empty)
    }

    func presentCreateProject() {
        presentedSheet = .createProject
    }
}

extension ProjectCoordinator {

    enum NavigationView {
        case empty
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
