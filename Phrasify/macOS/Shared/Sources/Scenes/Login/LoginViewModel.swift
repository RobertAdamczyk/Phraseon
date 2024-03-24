//
//  LoginViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 16.03.24.
//

import SwiftUI
import Domain
import AuthenticationServices

final class LoginViewModel: ObservableObject, Activitable {

    typealias LoginCoordinator = Coordinator & StartActions

    @Published var email: String = ""
    @Published var password: String = ""

    @Published var shouldShowActivityView: Bool = false

    private let coordinator: LoginCoordinator

    private lazy var signInWithAppleUseCase: SignInWithAppleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository,
              firestoreRepository: coordinator.dependencies.firestoreRepository)
    }()

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    func onForgetPasswordTapped() {
        coordinator.showForgetPassword()
    }

    @MainActor
    func onLoginTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.login(email: email, password: password)
            ToastView.showSuccess(message: "Login successful. Welcome back!")
        } catch {
            let errorHandler: ErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    @MainActor
    func onLoginWithGoogleTapped() {
        guard let window = NSApplication.shared.mainWindow else { return }
        startActivity()
        Task {
            do {
                let credentials = try await coordinator.dependencies.authenticationRepository.getGoogleAuthCredential(on: window)
                _ = try await coordinator.dependencies.authenticationRepository.login(with: credentials)
                ToastView.showSuccess(message: "Login successful. Welcome!")
            } catch {
                let errorHandler: ErrorHandler = .init(error: error)
                if !errorHandler.shouldIgnoreError {
                    ToastView.showError(message: errorHandler.localizedDescription)
                }
            }
            stopActivity()
        }
    }

    func onLoginWithAppleTapped(request: ASAuthorizationAppleIDRequest) {
        signInWithAppleUseCase.performLogin(request: request)
    }

    @MainActor
    func handleLoginWithApple(result: Result<ASAuthorization, any Error>) {
        startActivity()
        Task {
            do {
                try await signInWithAppleUseCase.completeLogin(result: result)
                ToastView.showSuccess(message: "Login successful. Welcome!")
            } catch {
                let errorHandler: ErrorHandler = .init(error: error)
                if !errorHandler.shouldIgnoreError {
                    ToastView.showError(message: errorHandler.localizedDescription)
                }
            }
            stopActivity()
        }
    }
}
