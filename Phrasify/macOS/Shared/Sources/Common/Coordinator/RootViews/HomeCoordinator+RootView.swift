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

        init(coordinator: HomeCoordinator.ParentCoordinator) {
            self._homeCoordinator = .init(wrappedValue: .init(parentCoordinator: coordinator))
        }

        var body: some View {
            NavigationStack(path: $homeCoordinator.navigationViews) {
                HomeView(coordinator: homeCoordinator)
                    .navigationDestination(for: HomeCoordinator.NavigationView.self) {
                        switch $0 {
                        case .empty: EmptyView()
                        }
                    }
            }
        }
    }
}
