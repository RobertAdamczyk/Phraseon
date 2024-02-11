//
//  DeleteKeyWarningViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

final class DeleteKeyWarningViewModel: StandardWarningProtocol {

    typealias DeleteKeyWarningCoordinator = Coordinator & SheetActions & NavigationActions

    @Published var isLoading: Bool = false

    var title: String = "Are you sure ?"
    var subtitle: String = "This action is irreversible and once deleted, the phrase cannot be recovered. Please confirm if you wish to proceed with deletion."
    var buttonText: String = "Delete phrase"

    private let key: Key
    private let project: Project
    private let coordinator: DeleteKeyWarningCoordinator

    init(coordinator: DeleteKeyWarningCoordinator, project: Project, key: Key) {
        self.coordinator = coordinator
        self.project = project
        self.key = key
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id, let keyId = key.id else { return }
        isLoading = true
        do {
            try await coordinator.dependencies.cloudRepository.deleteKey(.init(projectId: projectId, keyId: keyId))
            coordinator.dismissSheet()
            coordinator.popView()
            ToastView.showSuccess(message: "Key successfully deleted.")
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
            coordinator.dismissSheet()
        }
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}

