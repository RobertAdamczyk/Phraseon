//
//  SelectMemberRoleViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

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
                try await coordinator.dependencies.cloudRepository.changeMemberRole(userId: userId, projectId: projectId, role: selectedRole)
                coordinator.popView()
            case .invite:
                try await coordinator.dependencies.cloudRepository.addProjectMember(userId: userId, projectId: projectId, role: selectedRole)
                coordinator.dismissFullScreenCover()
            }

        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}

extension SelectMemberRoleViewModel {

    enum Context {
        case members(member: Member)
        case invite(user: User)
    }
}
