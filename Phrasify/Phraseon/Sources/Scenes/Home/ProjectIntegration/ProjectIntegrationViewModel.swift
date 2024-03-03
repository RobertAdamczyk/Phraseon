//
//  ProjectIntegrationViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI
import Model

final class ProjectIntegrationViewModel: ObservableObject {

    typealias ProjectIntegrationCoordinator = Coordinator

    @Published var shouldShowExportSheet: Bool = false

    var syncScriptFile: SyncScript? {
        .init(userId: coordinator.dependencies.authenticationRepository.userId, projectId: project.id)
    }

    private let project: Project
    private let coordinator: ProjectIntegrationCoordinator

    init(coordinator: ProjectIntegrationCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onExportTapped() {
        shouldShowExportSheet = true
    }

    func onExportCompletion(result: Result<URL, Error>) {
        print(result)
    }
}
