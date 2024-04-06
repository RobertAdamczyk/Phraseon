//
//  ProfileNameViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI
import Model

final class ProfileNameViewModel: ObservableObject {

    typealias ProfileNameCoordinator = Coordinator & SheetActions

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
            coordinator.dismissSheet()
        } catch {
            ToastView.showGeneralError()
        }
    }

    func onCancelButtonTapped() {
        coordinator.dismissSheet()
    }
}


