//
//  ChangePasswordViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI
import Combine
import Model
import Domain
import Common

final class ChangePasswordViewModel: ObservableObject {

    typealias ChangePasswordCoordinator = Coordinator & SheetActions

    @Published private(set) var state: State
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""

    var utility: Utility {
        .init(state: state, authenticationProvider: authenticationProvider)
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
                coordinator.dismissSheet()
            case .unavailable:
                coordinator.dismissSheet()
            }
        } catch {
            let errorHandler: ErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    func onCancelButtonTapped() {
        coordinator.dismissSheet()
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
