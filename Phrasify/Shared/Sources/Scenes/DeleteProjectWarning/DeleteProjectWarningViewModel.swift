//
//  DeleteProjectWarningViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 08.01.24.
//

import SwiftUI
import Model
import Domain

final class DeleteProjectWarningViewModel: StandardWarningProtocol {

    typealias DeleteProjectWarningCoordinator = Coordinator & SheetActions & NavigationActions

    @Published var isLoading: Bool = false

    var title: String = "Are you sure ?"

    var subtitle: String = "Please be aware that deleting a project is a permanent action and cannot be undone. By proceeding with this action, the project will be permanently removed, and all members will lose access to it."

    var buttonText: String = "Delete project"

    private let project: Project
    private let coordinator: DeleteProjectWarningCoordinator

    init(coordinator: DeleteProjectWarningCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id else { return }
        isLoading = true
        do {
            try await coordinator.dependencies.cloudRepository.deleteProject(.init(projectId: projectId))
            coordinator.dismissSheet()
            coordinator.popToRoot()
            ToastView.showSuccess(message: "Project successfully deleted.")
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
            coordinator.dismissSheet()
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}
