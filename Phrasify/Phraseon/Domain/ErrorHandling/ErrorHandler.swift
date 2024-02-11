//
//  ErrorHandler.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 19.01.24.
//

import Foundation
import Firebase

struct ErrorHandler {

    enum CloudError: String {
        case memberNotFound = "MEMBER_NOT_FOUND"
        case roleNotFound = "ROLE_NOT_FOUND"
        case userNotFound = "USER_NOT_FOUND"
        case projectNotFound = "PROJECT_NOT_FOUND"
        case permissionDenied = "PERMISSION_DENIED"
        case userUnauthenticated = "USER_UNAUTHENTICATED"
        case databaseError = "DATABASE_ERROR"
        case invalidKeyID = "INVALID_KEY_ID"
        case keyAlreadyExists = "KEY_ALREADY_EXISTS"
        case alreadyMember = "ALREADY_MEMBER"
        case cannotDeleteSelf = "CAN_NOT_DELETE_SELF"
        case languageNotValid = "LANGUAGE_NOT_VALID"
        case technologyNotValid = "TECHNOLOGY_NOT_VALID"
        case accessExpired = "ACCESS_EXPIRED"
        case accessDenied = "ACCESS_DENIED"
        case projectCreationLimit = "PROJECT_CREATION_LIMIT"
        case phraseContentTooLong = "PHRASE_CONTENT_TOO_LONG"
    }

    let error: Error

    var localizedDescription: String? {
        if let authError = error as? AuthErrorCode {
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
            case .requiresRecentLogin:
                return "Your security is our priority. To ensure it's really you, please re-authenticate by logging in again."
            default:
                return "An unexpected error occurred. Please try again later. If the problem persists, contact our support team."
            }
        }

        if let cloudError = CloudError(rawValue: error.localizedDescription) {
            switch cloudError {
            case .memberNotFound:
                return "Member not found. Please check the member's data and try again."
            case .roleNotFound:
                return "Specified role does not exist. Please select a valid role."
            case .userNotFound:
                return "User not found. Ensure the user data are correct."
            case .projectNotFound:
                return "Project not found. Please verify the data."
            case .permissionDenied, .userUnauthenticated:
                return "Access denied. You do not have permission to perform this action."
            case .invalidKeyID:
                return "Invalid phrase ID. Please enter a valid phrase ID."
            case .keyAlreadyExists:
                return "This phrase already exists. Please use a different phrase."
            case .alreadyMember:
                return "Already a member of this project."
            case .languageNotValid:
                return "Invalid language. Please choose a valid language."
            case .technologyNotValid:
                return "Invalid technology. Please choose a valid technology option."
            case .cannotDeleteSelf:
                return "Can't remove yourself. Use 'Leave Project' instead."
            case .accessExpired:
                return "Your access period has expired. Please renew to continue enjoying our services."
            case .accessDenied:
                return "You do not have access to this service. Please check your subscription status or contact support."
            case .projectCreationLimit:
                return "You've reached your project limit. Upgrade your subscription to create more projects."
            case .phraseContentTooLong:
                if let details = (error as NSError).userInfo["details"] as? [String : Any], let maxLength = details["maxLength"] {
                    return "The provided phrase content is too long. Please shorten it to \(maxLength) characters or less."
                }
            case .databaseError:
                return nil
            }
        }
        return nil
    }
}
