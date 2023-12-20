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

    private let coordinator: RegisterCoordinator

    private lazy var googleUseCase: GoogleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository)
    }()

    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
    }

    func onLoginTapped() {
        coordinator.showLogin()
    }

    func onRegisterWithEmailTapped() {
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
            ToastView.showError(message: error.localizedDescription)
        }
        stopActivity()
    }
}
