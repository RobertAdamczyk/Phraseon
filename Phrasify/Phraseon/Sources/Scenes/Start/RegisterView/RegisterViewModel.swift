//
//  RegisterViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI
import Common
import AuthenticationServices

final class RegisterViewModel: ObservableObject, Activitable {

    typealias RegisterCoordinator = Coordinator & StartActions

    @Published var email: String = ""
    @Published var shouldShowActivityView: Bool = false

    let emailValidationHandler = EmailValidationHandler()

    private let coordinator: RegisterCoordinator
    private let cancelBag = CancelBag()

    private lazy var signInWithAppleUseCase: SignInWithAppleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository,
              firestoreRepository: coordinator.dependencies.firestoreRepository)
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
