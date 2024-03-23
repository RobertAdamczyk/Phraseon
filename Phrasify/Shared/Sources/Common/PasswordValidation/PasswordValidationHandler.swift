//
//  PasswordValidationHandler.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

final class PasswordValidationHandler: ValidationHandlerProtocol {

    enum ValidationError: ValidationErrorProtocol {
        case passwordsNotTheSame
        case passwordTooShort

        var localizedTitle: String {
            switch self {
            case .passwordsNotTheSame:
                return "The passwords you entered do not match. Please ensure that both password fields are identical."
            case .passwordTooShort:
                return "Your password is too short. Please ensure your password has at least 8 characters for security purposes."
            }
        }
    }

    @Published private(set) var validationError: ValidationError?
    @Published var shake: Bool = false

    func resetValidation() {
        validationError = nil
        shake = false
    }

    func validate(password: String, confirmPassword: String) -> Result<Void, ValidationError> {
        if password != confirmPassword {
            validationError = .passwordsNotTheSame
            return .failure(ValidationError.passwordsNotTheSame)
        }
        if password.count < 8 {
            validationError = .passwordTooShort
            return .failure(ValidationError.passwordTooShort)
        }
        validationError = nil
        return .success(Void())
    }
}
