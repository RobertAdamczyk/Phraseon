//
//  RegisterViewModel.swift
//  Phrasify
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

    private lazy var googleUseCase: GoogleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository)
    }()

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

    func onLoginWithGoogleTapped() {
        Task {
            do {
                try await googleUseCase.getGoogleAuthCredential() // Currently no error handling needed
                await loginWithGoogleCredentials()
            } catch {
                return
            }
        }
    }

    @MainActor
    private func loginWithGoogleCredentials() async {
        startActivity()
        do {
            try await googleUseCase.loginWithGoogleCredentials()
        } catch {
            let errorHandler: AuthenticationErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
        stopActivity()
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
