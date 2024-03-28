//
//  CreateProjectCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI
import Model

final class CreateProjectCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & SheetActions

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension CreateProjectCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension CreateProjectCoordinator: SheetActions {

    func dismissSheet() {
        parentCoordinator.dismissSheet()
    }
}

extension CreateProjectCoordinator: SelectLanguageActions {

    func showSelectLanguage(name: String) {
        let viewModel = SelectLanguageViewModel(coordinator: self, context: .createProject(name: name))
        let view: NavigationView = .selectLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }
    
    func showSelectedLanguages(project: Project) {
        // empty
    }
    
    func showSelectBaseLanguage(name: String, languages: [Language]) {
        let viewModel = SelectBaseLanguageViewModel(coordinator: self, context: .createProject(name: name, languages: languages))
        let view: NavigationView = .selectBaseLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }
    
    func showSelectedBaseLanguage(project: Project) {
        // empty
    }
}

extension CreateProjectCoordinator: SelectTechnologyActions {

    func showSelectTechnology(name: String, languages: [Model.Language], baseLanguage: Model.Language) {
        // empty
    }
    
    func showSelectedTechnologies(project: Model.Project) {
        // empty
    }
}

extension CreateProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectLanguage(viewModel: SelectLanguageViewModel)
        case selectBaseLanguage(viewModel: SelectBaseLanguageViewModel)
        // case selectTechnology(viewModel: SelectTechnologyViewModel)

        static func == (lhs: CreateProjectCoordinator.NavigationView, rhs: CreateProjectCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .selectLanguage: return "001"
            // case .selectTechnology: return "002"
            case .selectBaseLanguage: return "003"
            }
        }
    }
}
