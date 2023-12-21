//
//  ProjectDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

final class ProjectDetailViewModel: ObservableObject {

    typealias ProjectDetailCoordinator = Coordinator & RootActions

    @Published var selectedBar: ProjectDetailBar = .all
    @Published var searchText = ""

    let project: Project

    private let coordinator: ProjectDetailCoordinator

    init(coordinator: ProjectDetailCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onAddButtonTapped() {
        coordinator.presentCreateKey(project: project)
    }
}
