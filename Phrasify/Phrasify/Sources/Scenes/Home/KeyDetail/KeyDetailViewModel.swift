//
//  KeyDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

final class KeyDetailViewModel: ObservableObject {

    typealias KeyDetailCoordinator = Coordinator & EnterContentKeyActions & ProjectActions

    @Published var key: Key

    let project: Project
    private let coordinator: KeyDetailCoordinator
    private let cancelBag = CancelBag()

    init(coordinator: KeyDetailCoordinator, key: Key, project: Project) {
        self.coordinator = coordinator
        self.key = key
        self.project = project
        setupKeySubscriber()
    }

    func onCopyTapped(_ text: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }

    func onEditTranslationTapped(language: Language) {
        coordinator.showEditContentKey(language: language, key: key, project: project)
    }

    func onDeleteTapped() {
        coordinator.showDeleteKeyWarning(project: project, key: key)
    }

    private func setupKeySubscriber() {
        guard let projectId = project.id, let keyId = key.id else { return }
        coordinator.dependencies.firestoreRepository.getKeyPublisher(projectId: projectId, keyId: keyId)
            .receive(on: RunLoop.main)
            .sink { [weak self] key in
                guard let key else { return }
                DispatchQueue.main.async {
                    self?.key = key
                }
            }
            .store(in: cancelBag)
    }
}

