//
//  RegisterViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 23.03.24.
//

import SwiftUI
import Common
import AuthenticationServices
import Domain
import Combine

final class RegisterViewModel: ObservableObject, Activitable {

    typealias RegisterCoordinator = Coordinator & StartActions

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var shouldShowActivityView: Bool = false

    let emailValidationHandler = EmailValidationHandler()
    let passwordValidationHandler = PasswordValidationHandler()

    private let coordinator: RegisterCoordinator
    private let cancelBag = CancelBag()

    private lazy var signInWithAppleUseCase: SignInWithAppleUseCase = {
        .init(authenticationRepository: coordinator.dependencies.authenticationRepository,
              firestoreRepository: coordinator.dependencies.firestoreRepository)
    }()

    init(coordinator: RegisterCoordinator) {
        self.coordinator = coordinator
        setupTextSubscriber()
    }

    func onLoginTapped() {
        coordinator.showLogin()
    }

    @MainActor
    func onRegisterWithEmailTapped() async {
        guard case .success = emailValidationHandler.validate(email: email) else { return }
        guard case .success = passwordValidationHandler.validate(password: password, confirmPassword: confirmPassword) else { return }
        do {
            try await coordinator.dependencies.authenticationRepository.signUp(email: email, password: password)
            UserDefaults.standard.set(email, forKey: UserDefaults.Key.email.rawValue)
            ToastView.showSuccess(message: "Account successfully created. Welcome in Phraseon!")
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
            } catch {
                let errorHandler: ErrorHandler = .init(error: error)
                if !errorHandler.shouldIgnoreError {
                    ToastView.showError(message: errorHandler.localizedDescription)
                }
            }
            stopActivity()
        }
    }

    private func setupTextSubscriber() {
        Publishers.MergeMany($password, $confirmPassword, $email)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.passwordValidationHandler.resetValidation()
                    self?.emailValidationHandler.resetValidation()
                }
            })
            .store(in: cancelBag)
    }
}
