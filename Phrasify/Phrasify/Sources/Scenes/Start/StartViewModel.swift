//
//  StartViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

final class StartViewModel: ObservableObject {

    typealias StartCoordinator = Coordinator & StartActions

    private let coordinator: StartCoordinator

    init(coordinator: StartCoordinator) {
        self.coordinator = coordinator
    }

    func onSignInTapped() {
        coordinator.showLogin()
    }

    func onSignUpTapped() {
        coordinator.showRegister()
    }
}
