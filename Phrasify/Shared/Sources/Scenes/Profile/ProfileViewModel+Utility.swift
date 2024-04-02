//
//  ProfileViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 02.04.24.
//

import Model
import Common
import Domain
import Foundation

extension ProfileViewModel {

    struct Utility {

        private let user: DeferredData<User>
        private let authenticationRepository: AuthenticationRepository

        init(user: DeferredData<User>, authenticationRepository: AuthenticationRepository) {
            self.user = user
            self.authenticationRepository = authenticationRepository
        }

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

        private var possibleUserCreationDelay: Bool {
            guard user.isFailed else { return false }
            guard let creationDate = authenticationRepository.creationDate else { return false }
            // WORKAROUND ⚠️
            // In Backend there is a slight delay between registration and creation of a user in the database.
            // Therefore, in case of an error of no user for the first 30 seconds after registration show loading.
            return abs(creationDate.timeIntervalSinceNow) < 30
        }
    }
}
