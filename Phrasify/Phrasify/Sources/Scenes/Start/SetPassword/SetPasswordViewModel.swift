//
//  SetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI
import Combine

final class SetPasswordViewModel: ObservableObject {

    typealias SetPasswordCoordinator = Coordinator & StartActions & NavigationActions

    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    let passwordValidationHandler = PasswordValidationHandler()

    private let coordinator: SetPasswordCoordinator
    private let email: String
    private let cancelBag = CancelBag()

    init(email: String, coordinator: SetPasswordCoordinator) {
        self.coordinator = coordinator
        self.email = email
        setupPasswordTextSubscriber()
    }

    @MainActor
    func onCreateAccountTapped() async {
        guard case .success = passwordValidationHandler.validate(password: password, confirmPassword: confirmPassword) else { return }
        do {
            try await coordinator.dependencies.authenticationRepository.signUp(email: email, password: password)
            ToastView.showSuccess(message: "Account successfully created. Welcome in Phrasify!")
        } catch {
            let errorHandler: AuthenticationErrorHandler = .init(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    private func setupPasswordTextSubscriber() {
        Publishers.Merge($password, $confirmPassword)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.passwordValidationHandler.resetValidation()
                }
            })
            .store(in: cancelBag)
    }
}
