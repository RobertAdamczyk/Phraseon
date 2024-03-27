//
//  RootCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator = RootCoordinator()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    NavigationSplitView {
                        MenuView(coordinator: rootCoordinator)
                    } detail: {
                        switch rootCoordinator.selectedSplitView {
                        case .home:
                            HomeCoordinator.RootView(coordinator: rootCoordinator)
                        case .profile:
                            Text("PROFILE").navigationTitle("Profile")
                        }

                    }
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(coordinator: rootCoordinator)
                }
            }
        }
    }
}
