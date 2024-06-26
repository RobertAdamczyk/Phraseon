//
//  ProfileNameViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.01.24.
//

import SwiftUI
import Model

final class ProfileNameViewModel: ObservableObject {

    typealias ProfileNameCoordinator = Coordinator & NavigationActions

    @Published var name: String
    @Published var surname: String

    let utility: Utility = .init()

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.userId
    }

    private let coordinator: ProfileNameCoordinator

    init(name: String?, surname: String?, coordinator: ProfileNameCoordinator) {
        self.coordinator = coordinator
        self.name = name ?? ""
        self.surname = surname ?? ""
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let userId else { return }
        do {
            try await coordinator.dependencies.firestoreRepository.setProfileName(userId: userId, name: name, surname: surname)
            ToastView.showSuccess(message: "Your profile has been successfully updated.")
            coordinator.popView()
        } catch {
            ToastView.showGeneralError()
        }
    }
}

