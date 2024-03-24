//
//  ForgetPasswordViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 24.03.24.
//

import SwiftUI
import Common
import Domain

final class ForgetPasswordViewModel: ObservableObject {

    typealias ForgetPasswordCoordinator = Coordinator & SheetActions

    @Published var email: String = ""

    let emailValidationHandler = EmailValidationHandler()

    private let coordinator: ForgetPasswordCoordinator

    private let cancelBag = CancelBag()

    init(coordinator: ForgetPasswordCoordinator) {
        self.coordinator = coordinator
        setupEmailTextSubscriber()
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }

    @MainActor
    func onSendEmailTapped() async {
        guard case .success = emailValidationHandler.validate(email: email) else { return }
        do {
            try await coordinator.dependencies.authenticationRepository.sendResetPassword(email: email)
            coordinator.dismissSheet()
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


