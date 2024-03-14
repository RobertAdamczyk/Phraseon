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
import FirebaseAuth
#if canImport(UIKit)
import UIKit
#endif

public protocol AuthenticationRepository {

    var isLoggedInPublisher: Published<Bool?>.Publisher { get }

    var userId: UserID? { get }

    var email: String? { get }

    var authenticationProvider: AuthenticationProvider? { get }

    var creationDate: Date? { get }

    func login(email: String, password: String) async throws

    func login(with credential: AuthCredential) async throws -> AuthDataResult?

    func signUp(email: String, password: String) async throws

    func sendResetPassword(email: String) async throws

    func logout() throws

    func deleteUser() async throws

    func reauthenticate(email: String, password: String) async throws

    func updatePassword(to password: String) async throws

    #if canImport(UIKit)
    func getGoogleAuthCredential(on viewController: UIViewController) async throws -> AuthCredential
    #else
    func getGoogleAuthCredential(on viewController: NSWindow) async throws -> AuthCredential
    #endif
}

public final class AuthenticationRepositoryImpl: AuthenticationRepository {

    // MARK: Public properties

    @Published private var isLoggedIn: Bool?

    public var isLoggedInPublisher: Published<Bool?>.Publisher { $isLoggedIn }

    public var userId: UserID? {
        auth.currentUser?.uid
    }

    public var email: String? {
        auth.currentUser?.email
    }

    public var authenticationProvider: AuthenticationProvider? {
        auth.currentUser?.authenticationProvider
    }

    public var creationDate: Date? {
        auth.currentUser?.metadata.creationDate
    }

    // MARK: Private properties

    private let auth = Auth.auth()

    // MARK: Lifecycle

    public init() {
        auth.useAppLanguage() // TODO: Check this
        setupStateDidChangeListener()
    }

    // MARK: Public functions

    public func login(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    public func login(with credential: AuthCredential) async throws -> AuthDataResult? {
        return try await auth.signIn(with: credential)
    }

    public func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }

    public func sendResetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    public func logout() throws {
        try auth.signOut()
    }

    public func deleteUser() async throws {
        try await auth.currentUser?.delete()
    }

    public func reauthenticate(email: String, password: String) async throws {
        try await auth.currentUser?.reauthenticate(with: EmailAuthProvider.credential(withEmail: email, password: password))
    }

    public func updatePassword(to password: String) async throws {
        try await auth.currentUser?.updatePassword(to: password)
    }

    #if canImport(UIKit)
    @MainActor
    public func getGoogleAuthCredential(on viewController: UIViewController) async throws -> AuthCredential {
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
    #else
    @MainActor
    public func getGoogleAuthCredential(on window: NSWindow) async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw AppError.idClientNil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: window)
        guard let idToken = result.user.idToken?.tokenString else { throw AppError.idTokenNil }

        return GoogleAuthProvider.credential(withIDToken: idToken,
                                             accessToken: result.user.accessToken.tokenString)
    }
    #endif

    private func setupStateDidChangeListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            self?.isLoggedIn = user != nil
        }
    }
}
