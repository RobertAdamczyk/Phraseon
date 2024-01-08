//
//  DeleteProjectWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 08.01.24.
//

import SwiftUI

final class DeleteProjectWarningViewModel: ObservableObject {

    typealias DeleteProjectWarningCoordinator = Coordinator & SheetActions & NavigationActions

    private let project: Project
    private let coordinator: DeleteProjectWarningCoordinator

    init(coordinator: DeleteProjectWarningCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    @MainActor
    func onDeleteProjectTapped() async {
        guard let projectId = project.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.deleteProject(projectId: projectId)
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
