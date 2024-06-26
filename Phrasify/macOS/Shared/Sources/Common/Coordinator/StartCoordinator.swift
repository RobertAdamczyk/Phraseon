//
//  StartCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

final class StartCoordinator: ObservableObject, Coordinator {

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

extension StartCoordinator: StartActions {

    func showLogin() {
        let viewModel = LoginViewModel(coordinator: self)
        let navigationView: NavigationView = .login(viewModel: viewModel)
        navigationViews.append(navigationView)
    }

    func showRegister() {
        let viewModel = RegisterViewModel(coordinator: self)
        let navigationView: NavigationView = .register(viewModel: viewModel)
        navigationViews.append(navigationView)
    }

    func showForgetPassword() {
        let viewModel = ForgetPasswordViewModel(coordinator: self)
        self.presentedSheet = .forgetPassword(viewModel: viewModel)
    }
}

extension StartCoordinator: NavigationActions {

    func popView() {
        navigationViews.removeLast()
    }

    func popToRoot() {
        navigationViews.removeAll()
    }
}

extension StartCoordinator: SheetActions {

    func dismissSheet() {
        self.presentedSheet = nil
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

    enum Sheet: Identifiable {
        case forgetPassword(viewModel: ForgetPasswordViewModel)

        var id: String {
            switch self {
            case .forgetPassword: "001"
            }
        }
    }
}
