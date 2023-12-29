//
//  CreateKeyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

final class CreateKeyViewModel: ObservableObject {

    typealias CreateKeyCoordinator = Coordinator & CreateKeyActions

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
        coordinator.dismiss()
    }

    func onContinueButtonTapped() {
        coordinator.showEnterContentKey(keyId: keyId, project: project)
    }
}
