//
//  InviteMemberCoordinator+RootView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

extension InviteMemberCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: InviteMemberCoordinator

        private let project: Project

        init(parentCoordinator: InviteMemberCoordinator.ParentCoordinator, project: Project) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
            self.project = project
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                InviteMemberView(coordinator: coordinator, project: project)
                    .navigationDestination(for: InviteMemberCoordinator.NavigationView.self) {
                        switch $0 {
                        case .selectMemberRole(let viewModel): SelectMemberRole(viewModel: viewModel)
                        }
                    }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
