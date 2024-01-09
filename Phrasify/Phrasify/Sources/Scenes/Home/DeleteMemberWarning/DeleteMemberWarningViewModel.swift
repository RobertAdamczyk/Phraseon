//
//  DeleteMemberWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

final class DeleteMemberWarningViewModel: ObservableObject {

    typealias DeleteMemberWarningCoordinator = Coordinator & SheetActions & NavigationActions

    private let member: Member
    private let project: Project
    private let coordinator: DeleteMemberWarningCoordinator

    init(coordinator: DeleteMemberWarningCoordinator, project: Project, member: Member) {
        self.coordinator = coordinator
        self.project = project
        self.member = member
    }

    @MainActor
    func onDeleteMemberTapped() async {
        guard let projectId = project.id, let memberId = member.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.deleteMember(projectId: projectId, userId: memberId)
            coordinator.dismissSheet()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}
