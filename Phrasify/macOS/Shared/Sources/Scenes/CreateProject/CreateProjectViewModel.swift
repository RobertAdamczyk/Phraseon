//
//  CreateProjectViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

final class CreateProjectViewModel: ObservableObject {

    typealias CreateProjectCoordinator = Coordinator & SheetActions & SelectLanguageActions

    @Published var projectName: String = ""

    var shouldPrimaryButtonDisabled: Bool {
        projectName.count < 3
    }

    private let coordinator: CreateProjectCoordinator

    init(coordinator: CreateProjectCoordinator) {
        self.coordinator = coordinator
    }

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
    }

    func onContinueButtonTapped() {
        coordinator.showSelectLanguage(name: projectName)
    }
}


