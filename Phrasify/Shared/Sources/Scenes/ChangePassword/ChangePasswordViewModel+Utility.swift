//
//  ChangePasswordViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import Foundation
import Model

extension ChangePasswordViewModel {

    struct Utility {

        private let state: State
        private let authenticationProvider: AuthenticationProvider

        init(state: State, authenticationProvider: AuthenticationProvider) {
            self.state = state
            self.authenticationProvider = authenticationProvider
        }

        let navigationTitle: String = "Change password"

        var unavailableContentTitle: String {
            "Unavailable for \(providerTitle) Accounts"
        }

        var unavailableContentMessage: String {
            "Notice: As you're logged in using your \(providerTitle) account, the password for this app cannot be changed here. Your app login is linked to your \(providerTitle) account, and any password changes must be made through your \(providerTitle) account settings. Please visit \(providerTitle)'s account management to update your password. We appreciate your understanding and are here to assist with any other account inquiries you may have."
        }

        var shouldShowNewPassword: Bool {
            state == .newPassword || state == .confirmNewPassword
        }

        var shouldShowConfirmNewPassword: Bool {
            state == .confirmNewPassword
        }

        var shouldCurrentPasswordDisabled: Bool {
            switch state {
            case .newPassword, .unavailable, .confirmNewPassword: return true
            case .currentPassword: return false
            }
        }

        var primaryButtonText: String {
            switch state {
            case .currentPassword, .newPassword: return "Continue"
            case .confirmNewPassword: return "Change password"
            case .unavailable: return "Understood"
            }
        }

        var providerTitle: String {
            authenticationProvider.providerTitle
        }
    }
}
