//
//  ProjectDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI
import Combine

final class ProjectDetailViewModel: ObservableObject, ProjectMemberProtocol {

    typealias ProjectDetailCoordinator = Coordinator & ProjectActions

    @Published var selectedKeysOrder: KeysOrder = .alphabetically
    @Published var searchText = ""
    @Published private var keys: [Key] = []
    @Published internal var member: Member?

    var searchKeys: [Key] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { key in
                key.id?.lowercased().contains(searchText.lowercased()) == true
            }
        }
    }

    var shouldShowAddPhraseButton: Bool {
        isAdmin || isOwner || isDeveloper
    }

    let project: Project

    internal lazy var projectMemberUseCase: ProjectMemberUseCase = {
        .init(firestoreRepository: coordinator.dependencies.firestoreRepository,
              authenticationRepository: coordinator.dependencies.authenticationRepository,
              project: project)
    }()

    internal let cancelBag = CancelBag()
    private var keysTask: AnyCancellable?

    private let coordinator: ProjectDetailCoordinator

    init(coordinator: ProjectDetailCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupKeysSubscriber()
        setupSelectedKeysOrderSubscriber()
        setupMemberSubscriber()
    }

    func onAddButtonTapped() {
        coordinator.presentCreateKey(project: project)
    }

    func onSettingsTapped() {
        coordinator.showProjectSettings(project: project, projectMemberUseCase: projectMemberUseCase)
    }

    func onKeyTapped(_ key: Key) {
        coordinator.showKeyDetails(key: key, project: project)
    }

    private func setupSelectedKeysOrderSubscriber() {
        $selectedKeysOrder
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedKeysOrder in
                self?.setupKeysSubscriber()
            }
            .store(in: cancelBag)
    }

    private func setupKeysSubscriber() {
        guard let projectId = project.id else { return }
        keysTask?.cancel()
        keysTask = coordinator.dependencies.firestoreRepository.getKeysPublisher(projectId: projectId, keysOrder: selectedKeysOrder)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] keys in
                self?.keys = keys
            })
    }
}
