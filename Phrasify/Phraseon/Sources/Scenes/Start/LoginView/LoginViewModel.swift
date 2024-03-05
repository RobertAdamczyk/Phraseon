//
//  LoginViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI
import AuthenticationServices

final class LoginViewModel: ObservableObject, Activitable {

    typealias LoginCoordinator = Coordinator & StartActions

    @AppStorage(UserDefaults.Key.email.rawValue) var email: String = ""
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

    func onForgetPasswordTapped() {
        coordinator.showForgetPassword()
    }

    @MainActor
    func onLoginWithGoogleTapped() {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let viewController = windowScene.windows.first?.rootViewController else { return }
        startActivity()
        Task {
            do {
                let credentials = try await coordinator.dependencies.authenticationRepository.getGoogleAuthCredential(on: viewController)
                _ = try await coordinator.dependencies.authenticationRepository.login(with: credentials)
                ToastView.showSuccess(message: "Login successful. Welcome!")
            } catch {
                let errorHandler: ErrorHandler = .init(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
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
            } catch {
                let error = ErrorHandler(error: error)
                ToastView.showError(message: error.localizedDescription)
            }
            stopActivity()
        }
    }
}
