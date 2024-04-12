//
//  KeyDetailViewModel+Shared.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.04.24.
//

import Model
import Domain
import Foundation

extension KeyDetailViewModel {

    struct Utility {

        private let coordinator: KeyDetailCoordinator
        private let project: Project
        private let key: Key

        init(coordinator: KeyDetailCoordinator, project: Project, key: Key) {
            self.coordinator = coordinator
            self.project = project
            self.key = key
        }

        var shouldShowApproveButton: Bool {
            return project.members.count > 1
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
    }
}
