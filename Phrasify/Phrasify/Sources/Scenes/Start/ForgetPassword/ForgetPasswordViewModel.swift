//
//  ForgetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class ForgetPasswordViewModel: ObservableObject {

    typealias ForgetPasswordCoordinator = Coordinator & StartActions

    @Published var email: String = ""

    private let coordinator: ForgetPasswordCoordinator

    init(coordinator: ForgetPasswordCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onSendEmailTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.sendResetPassword(email: email)
            close()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    private func close() {
        coordinator.closeForgetPassword()
    }
}

