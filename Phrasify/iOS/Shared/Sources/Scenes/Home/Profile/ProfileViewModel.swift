//
//  ProfileViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 30.12.23.
//

import SwiftUI
import Model
import Common
import Domain

final class ProfileViewModel: ObservableObject, UserDomainProtocol {

    typealias ProfileCoordinator = Coordinator & ProfileActions & RootActions & NavigationActions & PaywallActions

    @Published var user: DeferredData<User>

    var shouldShowLoading: Bool {
        switch user {
        case .isLoading: 
            return true
        case .failed:
            return possibleUserCreationDelay
        case .idle, .loaded: 
            return false
        }
    }

    var shouldInteractionDisabled: Bool {
        switch user {
        case .failed, .idle, .isLoading: return true
        case .loaded: return false
        }
    }

    var shouldShowContent: Bool {
        guard !possibleUserCreationDelay else { return true }
        switch user {
        case .failed, .idle: return false
        case .loaded, .isLoading: return true
        }
    }

    var shouldShowError: Bool {
        guard !possibleUserCreationDelay else { return false }
        switch user {
        case .failed: return true
        default: return false
        }
    }

    var userName: String {
        guard let user = user.currentValue else { return "-" }

        let name = user.name ?? ""
        let surname = user.surname ?? ""

        let fullNameParts = [name, surname].filter { !$0.isEmpty }
        let fullName = fullNameParts.joined(separator: " ")

        if fullName.isEmpty {
            return "Enter your name"
        }

        return fullName
    }

    var subscriptionValidUntil: String {
        guard let validUntil = user.currentValue?.subscriptionValidUntil,
              let subscriptionStatus = user.currentValue?.subscriptionStatus else { return "Try for free" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        #if DEBUG
        formatter.timeStyle = .medium
        #endif
        if validUntil > .now {
            switch subscriptionStatus {
            case .trial: return "Trial ends " + formatter.string(from: validUntil)
            case .expires: return "Expires " + formatter.string(from: validUntil)
            case .renews: return "Renews " + formatter.string(from: validUntil)
            }
        } else {
            return "Expired " + formatter.string(from: validUntil)
        }
    }

    var userDomain: UserDomain {
        coordinator.dependencies.userDomain
    }

    let cancelBag = CancelBag()

    private var possibleUserCreationDelay: Bool {
        guard user.isFailed else { return false }
        guard let creationDate = coordinator.dependencies.authenticationRepository.creationDate else { return false }
        // WORKAROUND ⚠️
        // In Backend there is a slight delay between registration and creation of a user in the database.
        // Therefore, in case of an error of no user for the first 30 seconds after registration show loading.
        return abs(creationDate.timeIntervalSinceNow) < 30
    }

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
        coordinator.showProfileName(name: user.name, surname: user.surname)
    }

    func onPasswordTapped() {
        guard let provider = coordinator.dependencies.authenticationRepository.authenticationProvider else { return }
        coordinator.showChangePassword(authenticationProvider: provider)
    }

    func onMembershipTapped() {
        coordinator.presentPaywall()
    }

    func uploadProfileImage(_ uiImage: UIImage) async throws {
        guard let userId, let data = uiImage.jpegData(compressionQuality: 0.1) else { return }
        _ = try await coordinator.dependencies.storageRepository.uploadImage(path: .userImage(fileName: userId), imageData: data)
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