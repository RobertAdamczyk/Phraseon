//
//  RootCoordinator+RootView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator: RootCoordinator = .init()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    NavigationStack(path: $rootCoordinator.navigationViews) {
                        HomeView(coordinator: rootCoordinator)
                            .navigationDestination(for: RootCoordinator.NavigationView.self) {
                                switch $0 {
                                case .profile: Text("Profile")
                                case .projectDetails(let viewModel): ProjectDetailView(viewModel: viewModel)
                                }
                            }
                    }
                    .fullScreenCover(item: $rootCoordinator.presentedFullScreenCover) {
                        switch $0 {
                        case .newProject: NewProjectCoordinator.RootView(parentCoordinator: rootCoordinator)
                        }
                    }
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(parentCoordinator: rootCoordinator)
                }
            }
        }
    }
}
