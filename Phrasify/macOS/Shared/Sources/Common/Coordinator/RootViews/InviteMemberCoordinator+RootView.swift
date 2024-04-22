//
//  InviteMemberCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 22.04.24.
//

import SwiftUI
import Model

extension InviteMemberCoordinator {

    struct RootView: View {

        @StateObject private var inviteMemberCoordinator: InviteMemberCoordinator

        private let project: Project

        init(parentCoordinator: InviteMemberCoordinator.ParentCoordinator, project: Project) {
            self._inviteMemberCoordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
            self.project = project
        }

        var body: some View {
            NavigationStack(path: $inviteMemberCoordinator.navigationViews) {
                InviteMemberView(coordinator: inviteMemberCoordinator, project: project)
                    .navigationDestination(for: InviteMemberCoordinator.NavigationView.self) {
                        switch $0 {
                        case .selectMemberRole(let viewModel): SelectMemberRole(viewModel: viewModel)
                        }
                    }
            }
        }
    }
}
