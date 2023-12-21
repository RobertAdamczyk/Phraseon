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
    @Published var translation: String = ""

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

    }
}
