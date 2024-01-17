//
//  KeyDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

final class KeyDetailViewModel: ObservableObject, ProjectMemberUseCaseProtocol {

    typealias KeyDetailCoordinator = Coordinator & EnterContentKeyActions & ProjectActions

    @Published var key: Key
    @Published internal var member: Member?

    let project: Project
    private let coordinator: KeyDetailCoordinator
    internal let cancelBag = CancelBag()
    internal let projectMemberUseCase: ProjectMemberUseCase

    init(coordinator: KeyDetailCoordinator, key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        self.coordinator = coordinator
        self.key = key
        self.project = project
        self.projectMemberUseCase = projectMemberUseCase
        setupKeySubscriber()
        setupMemberSubscriber()
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

    func onApproveTapped(language: Language) async {
        try? await Task.sleep(nanoseconds: 1000000000)
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

