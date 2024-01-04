//
//  CreateProjectViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class CreateProjectViewModel: ObservableObject {

    typealias CreateProjectCoordinator = Coordinator & FullScreenCoverActions & SelectLanguageActions

    @Published var projectName: String = ""

    var shouldPrimaryButtonDisabled: Bool {
        projectName.count < 3
    }

    private let coordinator: CreateProjectCoordinator

    init(coordinator: CreateProjectCoordinator) {
        self.coordinator = coordinator
    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }

    func onContinueButtonTapped() {
        coordinator.showSelectLanguage(name: projectName)
    }
}

