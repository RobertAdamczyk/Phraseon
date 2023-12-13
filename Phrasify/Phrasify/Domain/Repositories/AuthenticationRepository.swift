//
//  AuthenticationRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Firebase
import Combine

final class AuthenticationRepository {

    // MARK: Public properties

    @Published private(set) var isLoggedIn: Bool?

    var currentUser: Firebase.User? {
        auth.currentUser
    }

    // MARK: Private properties

    private let auth = Auth.auth()

    // MARK: Lifecycle

    init() {
        auth.useAppLanguage() // TODO: Check this
        setupStateDidChangeListener()
    }

    // MARK: Public functions

    func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }

    func sendResetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    func logout() throws {
        try auth.signOut()
    }

    func deleteUser() async throws {
        try await auth.currentUser?.delete()
    }

    private func setupStateDidChangeListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}
