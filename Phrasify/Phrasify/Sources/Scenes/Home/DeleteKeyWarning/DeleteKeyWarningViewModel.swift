//
//  DeleteKeyWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

final class DeleteKeyWarningViewModel: ObservableObject {

    typealias DeleteKeyWarningCoordinator = Coordinator & SheetActions & NavigationActions

    private let key: Key
    private let project: Project
    private let coordinator: DeleteKeyWarningCoordinator

    init(coordinator: DeleteKeyWarningCoordinator, project: Project, key: Key) {
        self.coordinator = coordinator
        self.project = project
        self.key = key
    }

    @MainActor
    func onDeleteKeyTapped() async {
        guard let projectId = project.id, let keyId = key.id else { return }
        do {

            coordinator.dismissSheet()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}

