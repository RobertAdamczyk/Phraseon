//
//  CreateKeyViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI
import Model

final class CreateKeyViewModel: ObservableObject {

    typealias CreateKeyCoordinator = Coordinator & FullScreenCoverActions & EnterContentKeyActions

    @Published var keyId: String = ""

    var shouldDisablePrimaryButton: Bool {
        keyId.count < 3 || keyId.contains(" ")
    }

    let project: Project

    private let coordinator: CreateKeyCoordinator

    init(coordinator: CreateKeyCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    func onContinueButtonTapped() {
        coordinator.showEnterContentKey(keyId: keyId, project: project)
    }
}
