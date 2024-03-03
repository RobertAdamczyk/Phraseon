//
//  InviteMemberViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import Model

final class InviteMemberViewModel: ObservableObject {

    typealias InviteMemberCoordinator = Coordinator & FullScreenCoverActions & SelectMemberRoleActions

    @Published var email: String = ""

    var shouldPrimaryButtonDisabled: Bool {
        email.isEmpty
    }

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
            if let appError = error as? AppError {
                switch appError {
                case .alreadyMember: ToastView.showError(message: "This user is already a member of the project. Please add a different user or manage existing members.")
                case .notFound: ToastView.showError(message: "We couldn't find a user with the provided email address. Please double-check the email and try again.")
                default: ToastView.showGeneralError()
                }
            }
        }
    }

    @MainActor
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
