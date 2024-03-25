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
                        Text("XD")
                    } detail: {
                        NavigationStack(path: $rootCoordinator.navigationViews) {
                            HomeView(coordinator: rootCoordinator)
                                .navigationDestination(for: RootCoordinator.NavigationView.self) {
                                    switch $0 {
                                    case .empty: EmptyView()
                                    }
                                }
                        }
                    }
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(coordinator: rootCoordinator)
                }
            }
        }
    }
}
