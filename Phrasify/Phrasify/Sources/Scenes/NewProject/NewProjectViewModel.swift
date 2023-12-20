//
//  NewProjectViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class NewProjectViewModel: ObservableObject {

    typealias NewProjectCoordinator = Coordinator & NewProjectActions

    @Published var projectName: String = ""

    var shouldPrimaryButtonDisabled: Bool {
        projectName.count < 3
    }

    private let coordinator: NewProjectCoordinator

    init(coordinator: NewProjectCoordinator) {
        self.coordinator = coordinator
    }

    func onCloseButtonTapped() {
        coordinator.dismiss()
    }

    func onContinueButtonTapped() {
        coordinator.showSelectLanguage(name: projectName)
    }
}

