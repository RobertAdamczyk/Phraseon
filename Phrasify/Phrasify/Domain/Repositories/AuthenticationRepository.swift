//
//  AuthenticationRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Firebase
import Combine
import GoogleSignIn

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

    @MainActor
    func loginWithGoogle(with viewController: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw AppError.idClientNil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        guard let idToken = result.user.idToken?.tokenString else { throw AppError.idTokenNil }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: result.user.accessToken.tokenString)

        try await auth.signIn(with: credential)
    }

    private func setupStateDidChangeListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}
