//
//  SelectMemberRoleViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import Model

final class SelectMemberRoleViewModel: ObservableObject {

    typealias SelectMemberRoleCoordinator = Coordinator & FullScreenCoverActions & NavigationActions

    @Published var selectedRole: Role?

    var user: IdentifiableUser? {
        switch context {
        case .members(let member): return member
        case .invite(let user): return user
        }
    }

    var shouldButtonDisabled: Bool {
        selectedRole == nil
    }

    var buttonText: String {
        switch context {
        case .members: "Confirm change"
        case .invite: "Invite member"
        }
    }

    private let project: Project
    private let context: Context
    private let coordinator: SelectMemberRoleCoordinator

    init(coordinator: SelectMemberRoleCoordinator, project: Project, context: Context) {
        self.coordinator = coordinator
        self.project = project
        self.context = context
        if case .members(let member) = context {
            selectedRole = member.role
        }
    }

    func onRoleTapped(_ role: Role) {
        selectedRole = role
    }

    @MainActor
    func onSaveButtonTapped() async {
        guard let userId = user?.id, let projectId = project.id, let selectedRole else { return }
        do {
            switch context {
            case .members:
                try await coordinator.dependencies.cloudRepository.changeMemberRole(.init(userId: userId,
                                                                                          projectId: projectId,
                                                                                          role: selectedRole))
                coordinator.popView()
                ToastView.showSuccess(message: "Member role successfully changed to \(selectedRole.title).")
            case .invite:
                try await coordinator.dependencies.cloudRepository.addProjectMember(.init(userId: userId,
                                                                                          projectId: projectId,
                                                                                          role: selectedRole))
                coordinator.dismissFullScreenCover()
                ToastView.showSuccess(message: "Member successfully invited with the role of \(selectedRole.title).")
            }

        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}

extension SelectMemberRoleViewModel {

    enum Context {
        case members(member: Member)
        case invite(user: User)
    }
}
