//
//  SetPasswordViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

final class SetPasswordViewModel: ObservableObject {

    typealias SetPasswordCoordinator = Coordinator & StartActions

    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    private let coordinator: SetPasswordCoordinator

    init(coordinator: SetPasswordCoordinator) {
        self.coordinator = coordinator
    }

    func onCreateAccountTapped() {
        coordinator.popToRoot()
    }
}
