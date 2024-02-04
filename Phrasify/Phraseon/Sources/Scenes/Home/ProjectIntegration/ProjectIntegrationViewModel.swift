//
//  ProjectIntegrationViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

final class ProjectIntegrationViewModel: ObservableObject {

    typealias ProjectIntegrationCoordinator = Coordinator

    @Published var shouldShowExportSheet: Bool = false

    private(set) lazy var syncScriptFile: SyncScript? = {
        .init(userId: coordinator.dependencies.authenticationRepository.currentUser?.uid, projectId: project.id)
    }()

    let defaultFilename: String = "syncPhrases"

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
