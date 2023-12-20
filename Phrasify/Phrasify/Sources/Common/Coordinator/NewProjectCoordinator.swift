//
//  NewProjectCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class NewProjectCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & RootActions

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension NewProjectCoordinator: NewProjectActions {

    func dismiss() {
        parentCoordinator.dismissFullScreenCover()
    }

    func popToRoot() {
        navigationViews.removeAll()
    }

    func showSelectLanguage(name: String) {
        let viewModel = SelectLanguageViewModel(coordinator: self, name: name)
        let view: NavigationView = .selectLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectTechnology(name: String, languages: [Language]) {
        let viewModel = SelectTechnologyViewModel(coordinator: self, name: name, languages: languages)
        let view: NavigationView = .selectTechnology(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension NewProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectLanguage(viewModel: SelectLanguageViewModel)
        case selectTechnology(viewModel: SelectTechnologyViewModel)

        static func == (lhs: NewProjectCoordinator.NavigationView, rhs: NewProjectCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .selectLanguage: return "001"
            case .selectTechnology: return "002"
            }
        }
    }
}
