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

    func showSelectLanguage() {
        let viewModel = SelectLanguageViewModel(coordinator: self)
        let view: NavigationView = .selectLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension NewProjectCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectLanguage(viewModel: SelectLanguageViewModel)

        static func == (lhs: NewProjectCoordinator.NavigationView, rhs: NewProjectCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .selectLanguage: return "001"
            }
        }
    }
}
