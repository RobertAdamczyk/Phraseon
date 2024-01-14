//
//  ProfileViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 30.12.23.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {

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
        guard let user else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: user.subscriptionValidUntil)
    }

    private let coordinator: ProfileCoordinator

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.currentUser?.uid
    }

    private let cancelBag = CancelBag()

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

    }

    func uploadProfileImage(_ uiImage: UIImage) async throws {
        guard let userId else { return }
        _ = try await coordinator.dependencies.storageRepository.uploadImage(path: .userImage(fileName: userId), image: uiImage)
        let url = try await coordinator.dependencies.storageRepository.downloadURL(for: .userImage(fileName: userId))
        try await coordinator.dependencies.firestoreRepository.setProfilePhotoUrl(userId: userId, photoUrl: url.absoluteString)
    }

    func onLogoutTapped() {
        do {
            try coordinator.dependencies.authenticationRepository.logout()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onDeleteAccountTapped() {
        coordinator.showProfileDeleteWarning()
    }

    private func setupUserSubscriber() {
        guard let userId else { return }
        coordinator.dependencies.firestoreRepository.getUserPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    self?.user = user
                }
            })
            .store(in: cancelBag)
    }
}
