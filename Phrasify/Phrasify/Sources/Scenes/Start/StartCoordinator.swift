//
//  StartCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

protocol StartActions {

    func showLogin()
    func showRegister()
}

final class StartCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }

    func createRootView() -> AnyView {
        .init(StartView(coordinator: self))
    }
}

extension StartCoordinator: StartActions {

    func showLogin() {
        let viewModel = LoginViewModel(coordinator: self)
        let view: NavigationView = .login(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showRegister() {
        let viewModel = RegisterViewModel(coordinator: self)
        let view: NavigationView = .register(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension StartCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        static func == (lhs: StartCoordinator.NavigationView, rhs: StartCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        case login(viewModel: LoginViewModel)
        case register(viewModel: RegisterViewModel)

        var id: String {
            switch self {
            case .login: return "001"
            case .register: return "002"
            }
        }
    }
}
