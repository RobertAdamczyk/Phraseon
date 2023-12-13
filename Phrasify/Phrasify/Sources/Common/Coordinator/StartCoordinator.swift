//
//  StartCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

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

    func showForgetPassword() {
        let viewModel = ForgetPasswordViewModel(coordinator: self)
        let view: NavigationView = .forgetPassword(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSetPassword(email: String) {
        let viewModel = SetPasswordViewModel(email: email, coordinator: self)
        let view: NavigationView = .setPassword(viewModel: viewModel)
        navigationViews.append(view)
    }

    func closeForgetPassword() {
        navigationViews.removeAll(where: {
            if case .forgetPassword = $0 {
                return true
            }
            return false
        })
    }

    func popToRoot() {
        navigationViews.removeAll()
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
        case forgetPassword(viewModel: ForgetPasswordViewModel)
        case setPassword(viewModel: SetPasswordViewModel)

        var id: String {
            switch self {
            case .login: return "001"
            case .register: return "002"
            case .forgetPassword: return "003"
            case .setPassword: return "004"
            }
        }
    }
}
