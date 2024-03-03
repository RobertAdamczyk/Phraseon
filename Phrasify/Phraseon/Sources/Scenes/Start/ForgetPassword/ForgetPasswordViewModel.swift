//
//  ForgetPasswordViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI
import Common

final class ForgetPasswordViewModel: ObservableObject {

    typealias ForgetPasswordCoordinator = Coordinator & NavigationActions

    @Published var email: String = ""

    let emailValidationHandler = EmailValidationHandler()

    private let coordinator: ForgetPasswordCoordinator

    private let cancelBag = CancelBag()

    init(coordinator: ForgetPasswordCoordinator) {
        self.coordinator = coordinator
        setupEmailTextSubscriber()
    }

    @MainActor
    func onSendEmailTapped() async {
        guard case .success = emailValidationHandler.validate(email: email) else { return }
        do {
            try await coordinator.dependencies.authenticationRepository.sendResetPassword(email: email)
            coordinator.popView()
            ToastView.showSuccess(message: "An email with a password reset link has been sent. Please check your inbox.")
        } catch {
            let errorHandler: ErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    private func setupEmailTextSubscriber() {
        $email
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.emailValidationHandler.resetValidation()
                }
            })
            .store(in: cancelBag)
    }
}

