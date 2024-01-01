//
//  ProjectDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

final class ProjectDetailViewModel: ObservableObject {

    typealias ProjectDetailCoordinator = Coordinator & ProjectActions

    @Published var selectedKeysOrder: KeysOrder = .alphabetically
    @Published var searchText = ""
    @Published private var keys: [Key] = []

    var searchKeys: [Key] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { key in
                key.id?.lowercased().contains(searchText.lowercased()) == true
            }
        }
    }

    let project: Project

    let cancelBag = CancelBag()

    private let coordinator: ProjectDetailCoordinator

    init(coordinator: ProjectDetailCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupKeysSubscriber()
        setupSelectedKeysOrderSubscriber()
    }

    func onAddButtonTapped() {
        coordinator.presentCreateKey(project: project)
    }

    private func setupSelectedKeysOrderSubscriber() {
        $selectedKeysOrder
            .receive(on: RunLoop.main)
            .sink { selectedKeysOrder in
                self.setupKeysSubscriber()
            }
            .store(in: cancelBag)
    }

    private func setupKeysSubscriber() {
        guard let projectId = project.id else { return }
        coordinator.dependencies.firestoreRepository.getKeysPublisher(projectId: projectId, keysOrder: selectedKeysOrder)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] keys in
                self?.keys = keys
            })
            .store(in: cancelBag)
    }
}
