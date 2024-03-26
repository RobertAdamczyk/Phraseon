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
                        VStack(spacing: 16) {
                            Button {
                                rootCoordinator.selectedSplitView = .home
                            } label: {
                                Label("Home", systemImage: "house.fill")
                                    .apply(.bold, size: .L, color: .white)
                            }
                            Button {
                                rootCoordinator.selectedSplitView = .profile
                            } label: {
                                Label("Profile", systemImage: "person.fill")
                                    .apply(.bold, size: .L, color: .white)
                            }
                        }
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
