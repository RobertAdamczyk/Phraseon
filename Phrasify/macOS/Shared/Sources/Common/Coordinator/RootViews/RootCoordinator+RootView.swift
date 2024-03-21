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
                    NavigationSplitView(columnVisibility: $rootCoordinator.navigationSplitViewVisibility) {
                        Text("XD")
                    } detail: {
                        Text("HOME")
                            .onTapGesture {
                                try? rootCoordinator.dependencies.authenticationRepository.logout()
                            }
                    }
                } else if rootCoordinator.isLoggedIn == false {
                    NavigationSplitView(columnVisibility: $rootCoordinator.navigationSplitViewVisibility) {
                        Text("XD")
                    } detail: {
                        StartCoordinator.RootView(coordinator: rootCoordinator)
                    }
                }
            }
        }
    }
}
