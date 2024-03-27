//
//  HomeCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.03.24.
//

import SwiftUI

extension HomeCoordinator {

    struct RootView: View {

        @StateObject private var homeCoordinator: HomeCoordinator
        @StateObject private var profileCoordinator: ProfileCoordinator
        @StateObject private var projectCoordinator: ProjectCoordinator

        init(coordinator: HomeCoordinator.ParentCoordinator) {
            self._homeCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
            self._profileCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
            self._projectCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
        }

        var body: some View {
            NavigationSplitView {
                MenuView(coordinator: homeCoordinator)
            } detail: {
                switch homeCoordinator.selectedSplitView {
                case .home:
                    ProjectCoordinator.RootView(projectCoordinator: projectCoordinator)
                case .profile:
                    ProfileCoordinator.RootView(profileCoordinator: profileCoordinator)
                }
            }
        }
    }
}
