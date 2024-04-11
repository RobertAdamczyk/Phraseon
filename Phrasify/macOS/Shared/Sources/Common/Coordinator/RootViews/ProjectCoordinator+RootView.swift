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
                    .navigationDestination(for: ProjectCoordinator.NavigationView.self) {
                        switch $0 {
                        case .projectDetail(let viewModel): ProjectDetailView(viewModel: viewModel)
                        case .createKey(let viewModel): CreateKeyView(viewModel: viewModel)
                        }
                    }
            }
            .sheet(item: $projectCoordinator.presentedSheet) {
                switch $0 {
                case .createProject: CreateProjectCoordinator.RootView(coordinator: projectCoordinator)
                }
            }
        }
    }
}
