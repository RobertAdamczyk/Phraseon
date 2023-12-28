//
//  ProjectDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

final class ProjectDetailViewModel: ObservableObject {

    typealias ProjectDetailCoordinator = Coordinator & RootActions

    @Published var selectedBar: ProjectDetailBar = .alphabetically
    @Published var searchText = ""
    @Published var keys: [Key] = []

    let project: Project

    let cancelBag = CancelBag()

    private let coordinator: ProjectDetailCoordinator

    init(coordinator: ProjectDetailCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupKeysSubscriber()
        setupSelectedBarSubscriber()
    }

    func onAddButtonTapped() {
        coordinator.presentCreateKey(project: project)
    }

    private func setupSelectedBarSubscriber() {
        $selectedBar
            .receive(on: RunLoop.main)
            .sink { selectedBar in
                self.setupKeysSubscriber()
            }
            .store(in: cancelBag)
    }

    private func setupKeysSubscriber() {
        guard let projectId = project.id else { return }
        coordinator.dependencies.firestoreRepository.getKeysPublisher(projectId: projectId, order: selectedBar)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] keys in
                self?.keys = keys
            })
            .store(in: cancelBag)
    }
}
