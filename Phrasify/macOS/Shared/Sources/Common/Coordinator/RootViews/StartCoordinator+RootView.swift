//
//  StartCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

extension StartCoordinator {

    struct RootView: View {

        @StateObject private var startCoordinator: StartCoordinator

        init(coordinator: StartCoordinator.ParentCoordinator) {
            self._startCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
        }

        var body: some View {
            NavigationStack(path: $startCoordinator.navigationViews) {
                StartView(coordinator: startCoordinator)
                    .navigationDestination(for: StartCoordinator.NavigationView.self) {
                        switch $0 {
                        case .login(let viewModel): LoginView(viewModel: viewModel)
                        case .register(let viewModel): RegisterView(viewModel: viewModel)
                        }
                    }
            }
            .onDisappear(perform: startCoordinator.popToRoot)
        }
    }

}
