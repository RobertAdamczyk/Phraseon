//
//  ProfileViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 30.12.23.
//

import SwiftUI

final class ProfileViewModel: ObservableObject, UserDomainProtocol {

    typealias ProfileCoordinator = Coordinator & ProfileActions & RootActions & NavigationActions

    @Published var user: User?

    var userName: String {
        guard let user else { return "-" }

        if user.name.isEmpty && user.surname.isEmpty {
            return "Enter your name"
        }
        return user.name + " " + user.surname
    }

    var subscriptionValidUntil: String {
        guard let user, let validUntil = user.subscriptionValidUntil, 
              let subscriptionStatus = user.subscriptionStatus else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        #if DEBUG
        formatter.timeStyle = .medium
        #endif
        if validUntil > .now {
            switch subscriptionStatus {
            case .trial: return "Expires " + formatter.string(from: validUntil)
            case .premium: return "Renews " + formatter.string(from: validUntil)
            }
        } else {
            return "Expired " + formatter.string(from: validUntil)
        }
    }

    var userDomain: UserDomain {
        coordinator.dependencies.userDomain
    }

    let cancelBag = CancelBag()

    private let coordinator: ProfileCoordinator

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.currentUser?.uid
    }

    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        setupUserSubscriber()
    }

    func onNameTapped() {
        guard let user else { return }
        coordinator.showProfileName(name: user.name, surname: user.surname)
    }

    func onPasswordTapped() {
        guard let provider = coordinator.dependencies.authenticationRepository.currentUser?.authenticationProvider else { return }
        coordinator.showChangePassword(authenticationProvider: provider)
    }

    func onMembershipTapped() {
        coordinator.presentPaywall()
    }

    func uploadProfileImage(_ uiImage: UIImage) async throws {
        guard let userId else { return }
        _ = try await coordinator.dependencies.storageRepository.uploadImage(path: .userImage(fileName: userId), image: uiImage)
        let url = try await coordinator.dependencies.storageRepository.downloadURL(for: .userImage(fileName: userId))
        try await coordinator.dependencies.firestoreRepository.setProfilePhotoUrl(userId: userId, photoUrl: url.absoluteString)
    }

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
        coordinator.showProfileDeleteWarning()
    }
}
