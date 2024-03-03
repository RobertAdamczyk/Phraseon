//
//  AuthenticationRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Firebase
import Combine
import GoogleSignIn
import Model

protocol AuthenticationRepository {

    var isLoggedInPublisher: Published<Bool?>.Publisher { get }

    var userId: UserID? { get }

    var email: String? { get }

    var authenticationProvider: AuthenticationProvider? { get }

    func login(email: String, password: String) async throws

    func login(with credential: AuthCredential) async throws

    func signUp(email: String, password: String) async throws

    func sendResetPassword(email: String) async throws

    func logout() throws

    func deleteUser() async throws

    func reauthenticate(email: String, password: String) async throws

    func updatePassword(to password: String) async throws

    func getGoogleAuthCredential(on viewController: UIViewController) async throws -> AuthCredential
}

final class AuthenticationRepositoryImpl: AuthenticationRepository {

    // MARK: Public properties

    @Published private var isLoggedIn: Bool?

    var isLoggedInPublisher: Published<Bool?>.Publisher { $isLoggedIn }

    var userId: UserID? {
        auth.currentUser?.uid
    }

    var email: String? {
        auth.currentUser?.email
    }

    var authenticationProvider: AuthenticationProvider? {
        auth.currentUser?.authenticationProvider
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

    func login(with credential: AuthCredential) async throws {
        try await auth.signIn(with: credential)
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

    func reauthenticate(email: String, password: String) async throws {
        try await auth.currentUser?.reauthenticate(with: EmailAuthProvider.credential(withEmail: email, password: password))
    }

    func updatePassword(to password: String) async throws {
        try await auth.currentUser?.updatePassword(to: password)
    }

    @MainActor
    func getGoogleAuthCredential(on viewController: UIViewController) async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw AppError.idClientNil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        guard let idToken = result.user.idToken?.tokenString else { throw AppError.idTokenNil }

        return GoogleAuthProvider.credential(withIDToken: idToken,
                                             accessToken: result.user.accessToken.tokenString)
    }

    private func setupStateDidChangeListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}
