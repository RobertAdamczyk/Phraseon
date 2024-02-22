//
//  MockAuthenticationRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import Firebase

final class MockAuthenticationRepository: AuthenticationRepository {

    @Published var isLoggedIn: Bool? = true

    var isLoggedInPublisher: Published<Bool?>.Publisher {
        $isLoggedIn
    }

    var currentUser: Firebase.User? {
        return nil
    }

    func login(email: String, password: String) async throws {
        // empty
    }
    
    func login(with credential: AuthCredential) async throws {
        // empty
    }
    
    func signUp(email: String, password: String) async throws {
        // empty
    }
    
    func sendResetPassword(email: String) async throws {
        // empty
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
        return GoogleAuthProvider.credential(withIDToken: "", accessToken: "")
    }
}
