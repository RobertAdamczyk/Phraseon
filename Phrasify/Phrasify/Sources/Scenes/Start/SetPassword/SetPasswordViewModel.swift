//
//  SetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class SetPasswordViewModel: ObservableObject {

    typealias SetPasswordCoordinator = Coordinator & StartActions

    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    private let coordinator: SetPasswordCoordinator
    private let email: String

    init(email: String, coordinator: SetPasswordCoordinator) {
        self.coordinator = coordinator
        self.email = email
    }

    func onCreateAccountTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.signUp(email: email, password: password)
            print("SUCCESS Account Created")
        } catch {
            print("MAKE ERROR: \(error)") // TODO: ERROR
        }
    }

    private func close() {
        coordinator.popToRoot()
    }
}
