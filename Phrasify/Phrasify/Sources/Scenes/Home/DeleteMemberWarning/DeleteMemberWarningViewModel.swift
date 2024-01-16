//
//  DeleteMemberWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

final class DeleteMemberWarningViewModel: StandardWarningProtocol {

    typealias DeleteMemberWarningCoordinator = Coordinator & SheetActions & NavigationActions

    @Published var isLoading: Bool = false

    var title: String = "Are you sure ?"

    var subtitle: String = "The member will lose all access to the project resources and data. Please confirm if you wish to proceed with the removal."

    var buttonText: String = "Delete member"

    private let member: Member
    private let project: Project
    private let coordinator: DeleteMemberWarningCoordinator

    init(coordinator: DeleteMemberWarningCoordinator, project: Project, member: Member) {
        self.coordinator = coordinator
        self.project = project
        self.member = member
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id, let memberId = member.id else { return }
        isLoading = true
        do {
            try await coordinator.dependencies.cloudRepository.deleteMember(.init(projectId: projectId,
                                                                                  userId: memberId))
            coordinator.dismissSheet()
        } catch {
            ToastView.showError(message: error.localizedDescription)
            coordinator.dismissSheet()
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}
