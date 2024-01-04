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
                                case .profile(let viewModel): ProfileView(viewModel: viewModel)
                                case .profileName(let viewModel): ProfileNameView(viewModel: viewModel)
                                case .projectDetails(let viewModel): ProjectDetailView(viewModel: viewModel)
                                case .changePassword(let viewModel): ChangePasswordView(viewModel: viewModel)
                                }
                            }
                    }
                    .fullScreenCover(item: $rootCoordinator.presentedFullScreenCover) {
                        switch $0 {
                        case .createProject: CreateProjectCoordinator.RootView(parentCoordinator: rootCoordinator)
                        case .createKey(let project): CreateKeyCoordinator.RootView(parentCoordinator: rootCoordinator, project: project)
                        }
                    }
                    .sheet(item: $rootCoordinator.presentedSheet) {
                        switch $0 {
                        case .profileDeleteWarning(let viewModel): ProfileDeleteWarningView(viewModel: viewModel)
                        }
                    }
                    .confirmationDialog(item: $rootCoordinator.confirmationDialog)
                    .onDisappear(perform: rootCoordinator.popToRoot)
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(parentCoordinator: rootCoordinator)
                }
            }
        }
    }
}
