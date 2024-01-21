//
//  AuthenticationErrorHandler.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 19.01.24.
//

import Foundation
import Firebase

struct AuthenticationErrorHandler {

    let error: Error

    var localizedDescription: String? {
        guard let authError = error as? AuthErrorCode else { return nil }
        switch authError.code {
        case .wrongPassword, .invalidCredential:
            return "The credentials you entered are incorrect. Please check and try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support for assistance."
        case .emailAlreadyInUse:
            return "This email address is already associated with an account. If this is your email, please log in. If you forgot your password, use the 'Forgot Password' option."
        case .weakPassword:
            return "The password you have chosen is too weak. Please use a stronger password with a mix of letters, numbers, and symbols."
        case .accountExistsWithDifferentCredential:
            return "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address."
        case .tooManyRequests:
            return "We have detected too many requests from your device. Please wait for a while and try again later."
        case .userNotFound:
            return "No user found with this email address. Please check if you've entered it correctly or sign up for a new account."
        case .networkError:
            return "We're having trouble connecting to our servers. Please check your internet connection and try again."
        case .invalidPhoneNumber:
            return "The phone number you entered is invalid. Please enter a valid phone number and try again."
        case .invalidVerificationCode:
            return "The verification code entered is incorrect. Please check the code and try again."
        case .invalidEmail:
            return "The email address is incorrectly formatted. Please ensure it meets the standard email format requirements."
        default:
            return "An unexpected error occurred. Please try again later. If the problem persists, contact our support team."
        }
    }
}
