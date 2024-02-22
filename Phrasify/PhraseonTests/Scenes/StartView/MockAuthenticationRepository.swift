//
//  MockAuthenticationRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 22.02.24.
//

import Foundation
@testable import Phraseon_InHouse
import Firebase

final class MockAuthenticationRepository: AuthenticationRepository {

    @Published var isLoggedIn: Bool? = false

    var isLoggedInPublisher: Published<Bool?>.Publisher { $isLoggedIn }

    var currentUser: Firebase.User? { nil }

    var emailToLogin: String = ""
    var passwordToLogin: String = ""
    var credentialToLogin: AuthCredential?
    var sendResetPasswordEmail: String = ""

    func login(email: String, password: String) async throws {
        emailToLogin = email
        passwordToLogin = password
    }

    func login(with credential: AuthCredential) async throws {
        credentialToLogin = credential
    }

    func signUp(email: String, password: String) async throws {
        // empty
    }

    func sendResetPassword(email: String) async throws {
        sendResetPasswordEmail = email
    }

    func logout() throws {
        // empty
    }

    func deleteUser() async throws {
        // empty
    }

    func reauthenticate(email: String, password: String) async throws {
        // empty
    }

    func updatePassword(to password: String) async throws {
        // empty
    }

    func getGoogleAuthCredential(on viewController: UIViewController) async throws -> AuthCredential {
        return GoogleAuthProvider.credential(withIDToken: "GOOGLE", accessToken: "GOOGLE")
    }
}
