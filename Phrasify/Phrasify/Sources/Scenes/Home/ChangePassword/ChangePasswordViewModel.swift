//
//  ChangePasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 01.01.24.
//

import SwiftUI

final class ChangePasswordViewModel: ObservableObject {

    typealias ChangePasswordCoordinator = Coordinator & RootActions

    @Published private(set) var state: State
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""

    var primaryButtonText: String {
        switch state {
        case .currentPassword: return "Continue"
        case .newPassword: return "Change password"
        case .unavailable: return "Understood"
        }
    }

    private let coordinator: ChangePasswordCoordinator

    private var email: String? {
        coordinator.dependencies.authenticationRepository.currentUser?.email
    }

    private let authenticationProvider: AuthenticationProvider

    init(authenticationProvider: AuthenticationProvider, coordinator: ChangePasswordCoordinator) {
        self.coordinator = coordinator
        self.authenticationProvider = authenticationProvider
        self.state = {
            switch authenticationProvider {
            case .password: return .currentPassword
            case .google: return .unavailable
            }
        }()
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
                try await coordinator.dependencies.authenticationRepository.updatePassword(to: newPassword)
                coordinator.popView()
            case .unavailable:
                coordinator.popView()
            }
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}

extension ChangePasswordViewModel {

    enum State {
        case unavailable // for example google login
        case currentPassword
        case newPassword
    }
}
