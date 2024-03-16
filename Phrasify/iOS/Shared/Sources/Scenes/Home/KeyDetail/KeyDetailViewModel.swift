//
//  KeyDetailViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI
import Model
import Common
import Domain

final class KeyDetailViewModel: ObservableObject, ProjectMemberUseCaseProtocol {

    typealias KeyDetailCoordinator = Coordinator & EnterContentKeyActions & ProjectActions

    @Published var key: Key
    @Published internal var member: Member?

    var shouldShowApproveButton: Bool {
        return project.members.count > 1
    }

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

    @MainActor
    func onApproveTapped(language: Language) async {
        guard let projectId = project.id, let keyId = key.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.approveTranslation(.init(projectId: projectId, 
                                                                                        keyId: keyId,
                                                                                        language: language))
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    private func setupKeySubscriber() {
        guard let projectId = project.id, let keyId = key.id else { return }
        coordinator.dependencies.firestoreRepository.getKeyPublisher(projectId: projectId, keyId: keyId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] key in
                guard let key else { return }
                DispatchQueue.main.async {
                    self?.key = key
                }
            }
            .store(in: cancelBag)
    }
}

