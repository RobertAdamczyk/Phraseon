//
//  LoginViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class LoginViewModel: ObservableObject {

    typealias LoginCoordinator = Coordinator & StartActions

    @Published var email: String = ""
    @Published var password: String = ""

    private let coordinator: LoginCoordinator

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onLoginTapped() async {
        do {
            try await coordinator.dependencies.authenticationRepository.login(email: email, password: password)
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onForgetPasswordTapped() {
        coordinator.showForgetPassword()
    }

    func onLoginWithGoogleTapped() {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let viewController = windowScene.windows.first?.rootViewController else { return }
        Task {
            do {
                try await coordinator.dependencies.authenticationRepository.loginWithGoogle(with: viewController)
            } catch {
                print("ERROR: \(error.localizedDescription)")
                //ToastView.showError(message: error.localizedDescription)
            }
        }
    }
}

import GoogleSignIn
