//
//  CreateProjectCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class CreateProjectCoordinator: Coordinator, ObservableObject {

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

extension CreateProjectCoordinator: CreateProjectActions {

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

extension CreateProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectLanguage(viewModel: SelectLanguageViewModel)
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
            }
        }
    }
}
