//
//  ChangeProjectOwnerViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class ChangeProjectOwnerViewModel: ObservableObject {

    typealias ChangeProjectOwnerCoordinator = Coordinator & NavigationActions

    @Published var newProjectOwnerEmail: String = ""

    private let project: Project
    private let coordinator: ChangeProjectOwnerCoordinator

    init(coordinator: ChangeProjectOwnerCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    @MainActor
    func onProjectOwnerChangeTapped() async {
        guard let projectId = project.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.changeProjectOwner(.init(projectId: projectId,
                                                                                        newOwnerEmail: newProjectOwnerEmail))
            coordinator.popView()
            ToastView.showSuccess(message: "Project owner successfully changed to \(newProjectOwnerEmail).")
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}
