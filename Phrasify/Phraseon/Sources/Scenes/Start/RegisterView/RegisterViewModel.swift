//
//  RegisterViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class RegisterViewModel: ObservableObject, Activitable {

    typealias RegisterCoordinator = Coordinator & StartActions

    @Published var email: String = ""
    @Published var shouldShowActivityView: Bool = false

    let emailValidationHandler = EmailValidationHandler()

    private let coordinator: RegisterCoordinator
    private let cancelBag = CancelBag()

    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
        setupEmailTextSubscriber()
    }

    func onLoginTapped() {
        coordinator.showLogin()
    }

    func onRegisterWithEmailTapped() {
        guard case .success = emailValidationHandler.validate(email: email) else { return }
        coordinator.showSetPassword(email: email)
    }

    @MainActor
    func onLoginWithGoogleTapped() {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let viewController = windowScene.windows.first?.rootViewController else { return }
        startActivity()
        Task {
            do {
                let credentials = try await coordinator.dependencies.authenticationRepository.getGoogleAuthCredential(on: viewController)
                try await coordinator.dependencies.authenticationRepository.login(with: credentials)
                ToastView.showSuccess(message: "Login successful. Welcome!")
            } catch {
                let errorHandler: ErrorHandler = .init(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
            }
            stopActivity()
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
