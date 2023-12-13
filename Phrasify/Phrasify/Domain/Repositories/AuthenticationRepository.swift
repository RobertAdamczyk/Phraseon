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

    var isLoggedIn: Bool {
        auth.currentUser != nil
    }

    var currentUser: Firebase.User? {
        auth.currentUser
    }

    private let publisher: CurrentValueSubject<Bool, Never> = .init(false)

    // MARK: Private properties

    private let auth = Auth.auth()

    // MARK: Lifecycle

    init() {
        auth.useAppLanguage() // TODO: Check this
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

    func stateDidChangeListener(completion: @escaping (Firebase.User?) -> Void) {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.publisher.send(user != nil)
        }
    }
}
