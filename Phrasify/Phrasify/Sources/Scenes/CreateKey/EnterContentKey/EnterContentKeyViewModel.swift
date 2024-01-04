//
//  EnterContentKeyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

final class EnterContentKeyViewModel: ObservableObject {

    typealias EnterContentKeyCoordinator = Coordinator & CreateKeyActions & FullScreenCoverActions

    @Published var translation: String = ""

    private let coordinator: EnterContentKeyCoordinator
    private let keyId: String
    let project: Project

    init(coordinator: EnterContentKeyCoordinator, keyId: String, project: Project) {
        self.coordinator = coordinator
        self.keyId = keyId
        self.project = project
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id else { return }
        do {
            try await coordinator.dependencies.cloudRepository.createKey(projectId: projectId, keyId: keyId,
                                                                         translation: [project.baseLanguage.rawValue: translation])
            coordinator.dismissFullScreenCover()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}
