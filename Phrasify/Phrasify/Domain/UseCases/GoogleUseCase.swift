//
//  GoogleDomain.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.12.23.
//

import Firebase
import GoogleSignIn

final class GoogleUseCase {

    private var authCredential: AuthCredential?
    private let authenticationRepository: AuthenticationRepository

    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }

    @MainActor
    func getGoogleAuthCredential() async throws {
        guard let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
              let viewController = windowScene.windows.first?.rootViewController else { throw AppError.viewControllerNil }
        guard let clientID = FirebaseApp.app()?.options.clientID else { throw AppError.idClientNil }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        guard let idToken = result.user.idToken?.tokenString else { throw AppError.idTokenNil }

        authCredential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: result.user.accessToken.tokenString)
    }

    func loginWithGoogleCredentials() async throws {
        guard let authCredential else { throw AppError.googleAuthNil }
        try await authenticationRepository.login(with: authCredential)
    }
}
