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
                        case .empty: Text("EMPTY").navigationTitle("Empty")
                        }
                    }
            }
        }
    }
}
