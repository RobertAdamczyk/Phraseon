//
//  InviteMemberViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class InviteMemberViewModel: ObservableObject {

    typealias InviteMemberCoordinator = Coordinator & FullScreenCoverActions & SelectMemberRoleActions

    @Published var email: String = "robert.adamczyk@ffw.com" // TODO: DELETE

    private let project: Project
    private let coordinator: InviteMemberCoordinator

    init(coordinator: InviteMemberCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    @MainActor
    func onContinueTapped() async {
        do {
            let user = try await coordinator.dependencies.firestoreRepository.getUser(email: email)
            coordinator.showSelectMemberRole(email: email, project: project, user: user)
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }
}
