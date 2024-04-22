//
//  SelectMemberRoleViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 22.04.24.
//

import SwiftUI
import Model
import Domain

final class SelectMemberRoleViewModel: ObservableObject {

    typealias SelectMemberRoleCoordinator = Coordinator & SheetActions

    @Published var selectedRole: Role?

    var utility: Utility {
        .init(context: context, selectedRole: selectedRole)
    }

    var isInNavigationStack: Bool {
        switch context {
        case .members: return false
        case .invite: return true
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

    func onCancelButtonTapped() {
        coordinator.dismissSheet()
    }

    @MainActor
    func onSaveButtonTapped() async {
        guard let userId = utility.user?.id, let projectId = project.id, let selectedRole else { return }
        do {
            switch context {
            case .members:
                try await coordinator.dependencies.cloudRepository.changeMemberRole(.init(userId: userId,
                                                                                          projectId: projectId,
                                                                                          role: selectedRole))
                coordinator.dismissSheet()
                ToastView.showSuccess(message: "Member role successfully changed to \(selectedRole.title).")
            case .invite:
                try await coordinator.dependencies.cloudRepository.addProjectMember(.init(userId: userId,
                                                                                          projectId: projectId,
                                                                                          role: selectedRole))
                coordinator.dismissSheet()
                ToastView.showSuccess(message: "Member successfully invited with the role of \(selectedRole.title).")
            }

        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}
