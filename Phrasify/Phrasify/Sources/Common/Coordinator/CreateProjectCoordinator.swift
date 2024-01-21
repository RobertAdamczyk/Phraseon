//
//  CreateProjectCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class CreateProjectCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & RootActions & FullScreenCoverActions

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

extension CreateProjectCoordinator: FullScreenCoverActions {

    func dismissFullScreenCover() {
        parentCoordinator.dismissFullScreenCover()
    }
}

extension CreateProjectCoordinator: SelectTechnologyActions {

    func showSelectTechnology(name: String, languages: [Language], baseLanguage: Language) {
        let viewModel = SelectTechnologyViewModel(coordinator: self, context: .createProject(projectName: name,
                                                                                             languages: languages,
                                                                                             baseLanguage: baseLanguage))
        let view: NavigationView = .selectTechnology(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectedTechnologies(project: Project) {
        // empty implementation
    }
}

extension CreateProjectCoordinator: SelectLanguageActions {

    func showSelectLanguage(name: String) {
        let viewModel = SelectLanguageViewModel(coordinator: self, context: .createProject(name: name))
        let view: NavigationView = .selectLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectBaseLanguage(name: String, languages: [Language]) {
        let viewModel = SelectBaseLanguageViewModel(coordinator: self, context: .createProject(name: name, languages: languages))
        let view: NavigationView = .selectBaseLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectedLanguages(project: Project) {
        // empty implementation
    }

    func showSelectedBaseLanguage(project: Project) {
        // empty implementation
    }
}

extension CreateProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectLanguage(viewModel: SelectLanguageViewModel)
        case selectBaseLanguage(viewModel: SelectBaseLanguageViewModel)
        case selectTechnology(viewModel: SelectTechnologyViewModel)

        static func == (lhs: CreateProjectCoordinator.NavigationView, rhs: CreateProjectCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .selectLanguage: return "001"
            case .selectTechnology: return "002"
            case .selectBaseLanguage: return "003"
            }
        }
    }
}
