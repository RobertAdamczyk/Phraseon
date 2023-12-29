//
//  CreateKeyCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

final class CreateKeyCoordinator: Coordinator, ObservableObject {

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

extension CreateKeyCoordinator: CreateKeyActions {

    func dismiss() {
        parentCoordinator.dismissFullScreenCover()
    }

    func popToRoot() {
        navigationViews.removeAll()
    }

    func showEnterContentKey(keyId: String, project: Project) {
        let viewModel = EnterContentKeyViewModel(coordinator: self, keyId: keyId, project: project)
        let view: NavigationView = .enterContentKey(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension CreateKeyCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case enterContentKey(viewModel: EnterContentKeyViewModel)

        static func == (lhs: CreateKeyCoordinator.NavigationView, rhs: CreateKeyCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .enterContentKey: return "001"
            }
        }
    }
}
