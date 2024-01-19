//
//  ForgetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class ForgetPasswordViewModel: ObservableObject {

    typealias ForgetPasswordCoordinator = Coordinator & NavigationActions

    @Published var email: String = ""

    private let coordinator: ForgetPasswordCoordinator

    init(coordinator: ForgetPasswordCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onSendEmailTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.sendResetPassword(email: email)
            coordinator.popView()
            ToastView.showSuccess(message: "An email with a password reset link has been sent. Please check your inbox.")
        } catch {
            let errorHandler: AuthenticationErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}

