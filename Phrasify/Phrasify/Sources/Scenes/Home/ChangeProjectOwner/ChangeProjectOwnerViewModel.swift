//
//  ChangeProjectOwnerViewModel.swift
//  Phrasify
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
            try await coordinator.dependencies.cloudRepository.changeProjectOwner(projectId: projectId, newOwnerEmail: newProjectOwnerEmail)
            coordinator.popView()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}
