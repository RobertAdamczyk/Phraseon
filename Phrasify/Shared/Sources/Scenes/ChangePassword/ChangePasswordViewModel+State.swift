//
//  ChangePasswordViewModel+State.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import Foundation

extension ChangePasswordViewModel {

    enum State {
        case unavailable // for google/apple login
        case currentPassword
        case newPassword
        case confirmNewPassword
    }
}
