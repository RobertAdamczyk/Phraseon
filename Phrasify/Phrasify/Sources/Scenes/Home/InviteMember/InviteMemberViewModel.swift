//
//  InviteMemberViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class InviteMemberViewModel: ObservableObject {

    typealias InviteMemberCoordinator = Coordinator & FullScreenCoverActions & SelectMemberRoleActions

    @Published var email: String = ""

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
            try checkIsUserAlreadyProjectMember(userId: user.id)
            coordinator.showSelectMemberRole(email: email, project: project, user: user)
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    private func checkIsUserAlreadyProjectMember(userId: UserID?) throws {
        guard let userId else { throw AppError.notFound }
        if project.members.contains(where: { $0 == userId }) {
            throw AppError.alreadyMember
        }
    }
}
