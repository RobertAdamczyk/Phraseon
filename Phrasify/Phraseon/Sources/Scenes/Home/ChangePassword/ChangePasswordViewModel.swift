//
//  ChangePasswordViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.01.24.
//

import SwiftUI
import Combine
import Model
import Domain
import Common

final class ChangePasswordViewModel: ObservableObject {

    typealias ChangePasswordCoordinator = Coordinator & RootActions & NavigationActions

    @Published private(set) var state: State
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""

    var shouldShowNewPassword: Bool {
        state == .newPassword || state == .confirmNewPassword
    }

    var shouldShowConfirmNewPassword: Bool {
        state == .confirmNewPassword
    }

    var primaryButtonText: String {
        switch state {
        case .currentPassword, .newPassword: return "Continue"
        case .confirmNewPassword: return "Change password"
        case .unavailable: return "Understood"
        }
    }

    var providerTitle: String {
        authenticationProvider.providerTitle
    }

    let passwordValidationHandler = PasswordValidationHandler()

    private let coordinator: ChangePasswordCoordinator

    private var email: String? {
        coordinator.dependencies.authenticationRepository.email
    }

    private let authenticationProvider: AuthenticationProvider
    private let cancelBag = CancelBag()

    init(authenticationProvider: AuthenticationProvider, coordinator: ChangePasswordCoordinator) {
        self.coordinator = coordinator
        self.authenticationProvider = authenticationProvider
        self.state = {
            switch authenticationProvider {
            case .password: return .currentPassword
            case .google, .apple: return .unavailable
            }
        }()
        setupPasswordTextSubscriber()
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let email else { return }
        do {
            switch state {
            case .currentPassword:
                try await coordinator.dependencies.authenticationRepository.reauthenticate(email: email, password: currentPassword)
                state = .newPassword
            case .newPassword:
                state = .confirmNewPassword
            case .confirmNewPassword:
                guard case .success = passwordValidationHandler.validate(password: newPassword,
                                                                         confirmPassword: confirmNewPassword) else { return }
                try await coordinator.dependencies.authenticationRepository.updatePassword(to: newPassword)
                ToastView.showSuccess(message: "Your password has been successfully changed.")
                coordinator.popView()
            case .unavailable:
                coordinator.popView()
            }
        } catch {
            let errorHandler: ErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    private func setupPasswordTextSubscriber() {
        Publishers.MergeMany($newPassword, $confirmNewPassword, $currentPassword)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.passwordValidationHandler.resetValidation()
                }
            })
            .store(in: cancelBag)
    }
}

extension ChangePasswordViewModel {

    enum State {
        case unavailable // for google/apple login
        case currentPassword
        case newPassword
        case confirmNewPassword
    }
}
