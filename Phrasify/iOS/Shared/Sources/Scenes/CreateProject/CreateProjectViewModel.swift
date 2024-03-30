//
//  CreateProjectViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class CreateProjectViewModel: ObservableObject {

    typealias CreateProjectCoordinator = Coordinator & FullScreenCoverActions & SelectLanguageActions

    @Published var projectName: String = ""

    var utility: Utility {
        .init(projectName: projectName)
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

