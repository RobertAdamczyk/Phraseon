//
//  ProfileCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI

extension ProfileCoordinator {

    struct RootView: View {

        @ObservedObject var profileCoordinator: ProfileCoordinator

        var body: some View {
            NavigationStack(path: $profileCoordinator.navigationViews) {
                ProfileView(coordinator: profileCoordinator)
                    .navigationDestination(for: ProfileCoordinator.NavigationView.self) {
                        switch $0 {
                        case .empty: Text("EMPTY").navigationTitle("Empty")
                        }
                    }
            }
            .sheet(item: $profileCoordinator.presentedSheet) {
                switch $0 {
                case .profileDeleteWarning(let viewModel): ProfileDeleteWarningView(viewModel: viewModel)
                case .profileName(let viewModel): ProfileNameView(viewModel: viewModel)
                case .changePassword(let viewModel): ChangePasswordView(viewModel: viewModel)
                case .paywall(let viewModel): PaywallView(viewModel: viewModel)
                }
            }
        }
    }
}
