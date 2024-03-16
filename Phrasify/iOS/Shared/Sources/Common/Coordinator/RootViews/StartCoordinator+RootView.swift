//
//  StartCoordinator+RootView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

extension StartCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: StartCoordinator

        init(parentCoordinator: StartCoordinator.ParentCoordinator) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                StartView(coordinator: coordinator)
                    .navigationDestination(for: StartCoordinator.NavigationView.self) {
                        switch $0 {
                        case .login(let viewModel): LoginView(viewModel: viewModel)
                        case .register(let viewModel): RegisterView(viewModel: viewModel)
                        case .forgetPassword(let viewModel): ForgetPasswordView(viewModel: viewModel)
                        case .setPassword(let viewModel): SetPasswordView(viewModel: viewModel)
                        }
                    }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
