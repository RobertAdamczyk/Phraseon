//
//  LeaveProjectWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class LeaveProjectWarningViewModel: StandardWarningProtocol {

    typealias LeaveProjectWarningCoordinator = Coordinator & SheetActions & NavigationActions

    @Published var isLoading: Bool = false

    var title: String = "Are you sure ?"

    var subtitle: String = "Please confirm if you wish to leave this project. Keep in mind that this action is irreversible. Once you leave, you will lose access to the project and will need a new invitation to rejoin."

    var buttonText: String = "Leave project"

    private let project: Project
    private let coordinator: LeaveProjectWarningCoordinator

    init(coordinator: LeaveProjectWarningCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id else { return }
        isLoading = true
        do {
            try await coordinator.dependencies.cloudRepository.leaveProject(.init(projectId: projectId))
            coordinator.dismissSheet()
            coordinator.popToRoot()
        } catch {
            ToastView.showError(message: error.localizedDescription)
            coordinator.dismissSheet()
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}

