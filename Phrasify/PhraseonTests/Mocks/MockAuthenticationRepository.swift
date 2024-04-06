//
//  MockAuthenticationRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 22.02.24.
//

import Foundation
import Firebase
import Domain
import Model

final class MockAuthenticationRepository: AuthenticationRepository {

    var mockAuthenticationProvider: AuthenticationProvider?
    var calledLogout: Bool?
    var calledDeleteUser: Bool?
    var mockCreationDate: Date?

    var userId: UserID? {
        "123"
    }

    var email: String? {
        "email"
    }

    var authenticationProvider: AuthenticationProvider? {
        mockAuthenticationProvider
    }

    var creationDate: Date? {
        mockCreationDate
    }

    @Published var isLoggedIn: Bool? = true

    var isLoggedInPublisher: Published<Bool?>.Publisher { $isLoggedIn }

    var enteredEmail: String? = nil
    var enteredPassword: String? = nil
    var enteredUpdatedPassword: String? = nil
    @Published var credentialToLogin: AuthCredential?

    func login(email: String, password: String) async throws {
        self.enteredEmail = email
        self.enteredPassword = password
    }

    func login(with credential: AuthCredential) async throws -> AuthDataResult? {
        credentialToLogin = credential
        return nil
    }

    func signUp(email: String, password: String) async throws {
        self.enteredEmail = email
        self.enteredPassword = password
    }

    func sendResetPassword(email: String) async throws {
        self.enteredEmail = email
    }

    func logout() throws {
        self.calledLogout = true
    }

    func deleteUser() async throws {
        self.calledDeleteUser = true
    }

    func reauthenticate(email: String, password: String) async throws {
        self.enteredEmail = email
        self.enteredPassword = password
    }

    func updatePassword(to password: String) async throws {
        self.enteredUpdatedPassword = password
    }

    func getGoogleAuthCredential() async throws -> AuthCredential {
        return GoogleAuthProvider.credential(withIDToken: "GOOGLE", accessToken: "GOOGLE")
    }
}
