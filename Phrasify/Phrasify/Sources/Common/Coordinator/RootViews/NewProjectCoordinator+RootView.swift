//
//  NewProjectCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

extension NewProjectCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: NewProjectCoordinator

        init(parentCoordinator: NewProjectCoordinator.ParentCoordinator) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                NewProjectView(coordinator: coordinator)
                    .navigationDestination(for: NewProjectCoordinator.NavigationView.self) {
                        switch $0 {
                        case .selectLanguage(let viewModel): SelectLanguageView(viewModel: viewModel)
                        case .selectTechnology(let viewModel): SelectTechnologyView(viewModel: viewModel)
                        }
                    }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
