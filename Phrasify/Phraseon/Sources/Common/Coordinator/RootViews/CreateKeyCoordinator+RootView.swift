//
//  CreateKeyCoordinator+RootView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

extension CreateKeyCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: CreateKeyCoordinator

        let project: Project

        init(parentCoordinator: CreateKeyCoordinator.ParentCoordinator, project: Project) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
            self.project = project
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                CreateKeyView(coordinator: coordinator, project: project)
                    .navigationDestination(for: CreateKeyCoordinator.NavigationView.self) {
                        switch $0 {
                        case .enterContentKey(let viewModel): EnterContentKeyView(viewModel: viewModel)
                        }
                    }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
