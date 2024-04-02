//
//  ProfileViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 01.04.24.
//

import SwiftUI
import Model
import Common
import Domain

final class ProfileViewModel: ObservableObject, UserDomainProtocol {

    typealias ProfileCoordinator = Coordinator & NavigationActions

    @Published var user: DeferredData<User>

    var utility: Utility {
        .init(user: user, authenticationRepository: coordinator.dependencies.authenticationRepository)
    }

    var userDomain: UserDomain {
        coordinator.dependencies.userDomain
    }

    let cancelBag = CancelBag()

    private let coordinator: ProfileCoordinator

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.userId
    }

    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        self.user = coordinator.dependencies.userDomain.user
        setupUserSubscriber()
    }

    func onNameTapped() {
        guard let user = user.currentValue else { return }
        // coordinator.showProfileName(name: user.name, surname: user.surname)
    }

    func onPasswordTapped() {
        guard let provider = coordinator.dependencies.authenticationRepository.authenticationProvider else { return }
        // coordinator.showChangePassword(authenticationProvider: provider)
    }

    func onMembershipTapped() {
        // coordinator.presentPaywall()
    }

//    func uploadProfileImage(_ uiImage: UIImage) async throws {
//        guard let userId, let data = uiImage.jpegData(compressionQuality: 0.1) else { return }
//        _ = try await coordinator.dependencies.storageRepository.uploadImage(path: .userImage(fileName: userId), imageData: data)
//        let url = try await coordinator.dependencies.storageRepository.downloadURL(for: .userImage(fileName: userId))
//        try await coordinator.dependencies.firestoreRepository.setProfilePhotoUrl(userId: userId, photoUrl: url.absoluteString)
//    }

    @MainActor
    func onLogoutTapped() {
        do {
            try coordinator.dependencies.authenticationRepository.logout()
            ToastView.showSuccess(message: "Logged out successfully. See you again soon!")
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    func onDeleteAccountTapped() {
        // coordinator.showProfileDeleteWarning()
    }
}

