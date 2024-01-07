//
//  SelectMemberRoleViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class SelectMemberRoleViewModel: ObservableObject {

    typealias SelectMemberRoleCoordinator = Coordinator & FullScreenCoverActions

    @Published var selectedRole: Role?

    var user: User? {
        switch context {
        case .members: return nil
        case .invite(let user): return user
        }
    }

    var shouldButtonDisabled: Bool {
        selectedRole == nil
    }

    private let project: Project
    private let context: Context
    private let coordinator: InviteMemberCoordinator

    init(coordinator: InviteMemberCoordinator, project: Project, context: Context) {
        self.coordinator = coordinator
        self.project = project
        self.context = context
    }

    func onRoleTapped(_ role: Role) {
        selectedRole = role
    }

    @MainActor
    func onSaveButtonTapped() async {
        guard let userId = user?.id, let projectId = project.id, let selectedRole else { return }
        do {
            try await coordinator.dependencies.cloudRepository.addProjectMember(userId: userId, projectId: projectId, role: selectedRole)
            coordinator.dismissFullScreenCover()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}

extension SelectMemberRoleViewModel {

    enum Context {
        case members
        case invite(user: User)
    }
}
