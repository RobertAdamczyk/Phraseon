//
//  LoginViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class LoginViewModel: ObservableObject, Activitable {

    typealias LoginCoordinator = Coordinator & StartActions

    @AppStorage("email") var email: String = ""
    @Published var password: String = ""
    @Published var shouldShowActivityView: Bool = false

    private let coordinator: LoginCoordinator

    private lazy var googleUseCase: GoogleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository)
    }()

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onLoginTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.login(email: email, password: password)
            ToastView.showSuccess(message: "Login successful. Welcome back!")
        } catch {
            let errorHandler: AuthenticationErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    func onForgetPasswordTapped() {
        coordinator.showForgetPassword()
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
            ToastView.showSuccess(message: "Login successful. Welcome !")
        } catch {
            let errorHandler: AuthenticationErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
        stopActivity()
    }

}
