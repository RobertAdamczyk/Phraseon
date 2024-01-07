//
//  LeaveProjectWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class LeaveProjectWarningViewModel: ObservableObject {

    enum Context {
        case owner
        case notOwner
    }

    typealias LeaveProjectWarningCoordinator = Coordinator & SheetActions & NavigationActions

    let context: Context

    private let project: Project
    private let coordinator: LeaveProjectWarningCoordinator

    init(coordinator: LeaveProjectWarningCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        if project.owner == coordinator.dependencies.authenticationRepository.currentUser?.uid {
            self.context = .owner
        } else {
            self.context = .notOwner
        }
    }

    @MainActor
    func onLeaveProjectTapped() async {
        guard let projectId = project.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.leaveProject(projectId: projectId)
            coordinator.dismissSheet()
            coordinator.popToRoot()
        } catch {
            ToastView.showError(message: error.localizedDescription)
            coordinator.dismissSheet()
        }
    }

    func onUnderstoodTapped() {
        coordinator.dismissSheet()
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}

