//
//  ForgetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class ForgetPasswordViewModel: ObservableObject {

    typealias ForgetPasswordCoordinator = Coordinator & StartActions

    @Published var email: String = ""

    private let coordinator: ForgetPasswordCoordinator

    init(coordinator: ForgetPasswordCoordinator) {
        self.coordinator = coordinator
    }

    func onSendEmailTapped() {
        coordinator.closeForgetPassword()
    }
}

