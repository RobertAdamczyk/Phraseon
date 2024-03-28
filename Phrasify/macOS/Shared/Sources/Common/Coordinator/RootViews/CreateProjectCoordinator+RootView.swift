//
//  CreateProjectCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

extension CreateProjectCoordinator {

    struct RootView: View {

        @StateObject private var createProjectCoordinator: CreateProjectCoordinator

        init(coordinator: CreateProjectCoordinator.ParentCoordinator) {
            self._createProjectCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
        }

        var body: some View {
            NavigationStack(path: $createProjectCoordinator.navigationViews) {
                CreateProjectView(coordinator: createProjectCoordinator)
                    .navigationDestination(for: CreateProjectCoordinator.NavigationView.self) {
                        switch $0 {
                        case .selectLanguage(let viewModel): SelectLanguageView(viewModel: viewModel)
                        }
                    }
            }
        }
    }
}
