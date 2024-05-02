//
//  ProjectIntegrationViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI
import Model

final class ProjectIntegrationViewModel: ObservableObject {

    typealias ProjectIntegrationCoordinator = Coordinator & NavigationActions

    private let project: Project
    private let coordinator: ProjectIntegrationCoordinator

    init(coordinator: ProjectIntegrationCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onUnderstoodTapped() {
        coordinator.popView()
    }
}
