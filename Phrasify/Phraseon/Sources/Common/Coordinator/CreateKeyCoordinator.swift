//
//  CreateKeyCoordinator.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

final class CreateKeyCoordinator: Coordinator, ObservableObject {

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

extension CreateKeyCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension CreateKeyCoordinator: FullScreenCoverActions {

    func dismissFullScreenCover() {
        parentCoordinator.dismissFullScreenCover()
    }
}

extension CreateKeyCoordinator: EnterContentKeyActions {

    func showEnterContentKey(keyId: String, project: Project) {
        let viewModel = EnterContentKeyViewModel(coordinator: self, project: project, context: .create(keyId: keyId))
        let view: NavigationView = .enterContentKey(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showEditContentKey(language: Language, key: Key, project: Project) {
        // empty implementation
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
