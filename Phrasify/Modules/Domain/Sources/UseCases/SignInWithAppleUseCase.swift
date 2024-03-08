//
//  SignInWithAppleUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 04.03.24.
//

import Foundation
import CryptoKit
import FirebaseAuth
import AuthenticationServices

public final class SignInWithAppleUseCase {

    private var currentNonce: String?

    private let authenticationRepository: AuthenticationRepository
    private let firestoreRepository: FirestoreRepository

    public init(authenticationRepository: AuthenticationRepository, firestoreRepository: FirestoreRepository) {
        self.authenticationRepository = authenticationRepository
        self.firestoreRepository = firestoreRepository
    }

    public func performLogin(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }

    public func completeLogin(result: Result<ASAuthorization, any Error>) async throws {
        switch result {
        case .success(let success):
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let currentNonce else {
                    fatalError("Invalid state: no login request was sent")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identityToken")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token.")
                    return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: currentNonce)

                let result = try await authenticationRepository.login(with: credential)
                updateNameIfNecessary(appleIDCredential: appleIDCredential, result: result)
            }
        case .failure(let error):
            throw error
        }
    }

    private func updateNameIfNecessary(appleIDCredential: ASAuthorizationAppleIDCredential, result: AuthDataResult?) {
        guard let result, result.additionalUserInfo?.isNewUser == true else { return }

        let fullName = [appleIDCredential.fullName?.givenName,
                        appleIDCredential.fullName?.middleName].compactMap { $0 }.joined(separator: " ")
        let surname = appleIDCredential.fullName?.familyName ?? ""
        Task {
            try? await firestoreRepository.setProfileName(userId: result.user.uid, name: fullName, surname: surname)
        }
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }
}
