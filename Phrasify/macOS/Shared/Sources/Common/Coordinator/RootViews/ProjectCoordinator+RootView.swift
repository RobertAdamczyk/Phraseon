//
//  ProjectCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI

extension ProjectCoordinator {

    struct RootView: View {

        @ObservedObject var projectCoordinator: ProjectCoordinator

        var body: some View {
            NavigationStack(path: $projectCoordinator.navigationViews) {
                ProjectsView(coordinator: projectCoordinator)
                    .navigationDestination(for: ProjectCoordinator.NavigationView.self) { view in
                        Group {
                            switch view {
                            case .projectDetail(let viewModel): ProjectDetailView(viewModel: viewModel)
                            case .keyDetail(let viewModel): KeyDetailView(viewModel: viewModel)
                            }
                        }
                        .sheet(item: $projectCoordinator.presentedSheet) {
                            switch $0 {
                            case .createProject: CreateProjectCoordinator.RootView(coordinator: projectCoordinator)
                            case .createKey(let viewModel): CreateKeyView(viewModel: viewModel)
                            }
                        }
                    }
            }
            .sheet(item: $projectCoordinator.presentedSheet) {
                switch $0 {
                case .createProject: CreateProjectCoordinator.RootView(coordinator: projectCoordinator)
                case .createKey(let viewModel): CreateKeyView(viewModel: viewModel)
                }
            }
        }
    }
}
