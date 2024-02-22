//
//  LoginViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 21.02.24.
//

import XCTest
@testable import Phraseon_InHouse
import Firebase

final class LoginViewModelTest: XCTestCase {

    func testInit() throws {
        let coordinator: LoginCoordinator = .init()
        let viewModel: LoginViewModel = .init(coordinator: coordinator)

        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.shouldShowActivityView)
    }

    func testOnForgetPasswordTapped() throws {
        let coordinator: LoginCoordinator = .init()
        let viewModel: LoginViewModel = .init(coordinator: coordinator)

        XCTAssertFalse(coordinator.showForgetPasswordCalled)
        viewModel.onForgetPasswordTapped()
        XCTAssertTrue(coordinator.showForgetPasswordCalled)
    }

    func testOnLoginTapped() async throws {
        let coordinator: LoginCoordinator = .init()
        let viewModel: LoginViewModel = .init(coordinator: coordinator)

        viewModel.email = "EMAIL_TEST"
        viewModel.password = "PASSWORD_TEST"

        await viewModel.onLoginTapped()
        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
        XCTAssertEqual(mockAuthRepo?.emailToLogin, "EMAIL_TEST")
        XCTAssertEqual(mockAuthRepo?.passwordToLogin, "PASSWORD_TEST")
    }

    @MainActor
    func testOnLoginWithGoogleTapped() throws {
        let coordinator: LoginCoordinator = .init()
        let viewModel: LoginViewModel = .init(coordinator: coordinator)

        viewModel.onLoginWithGoogleTapped()

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
        XCTAssertEqual(mockAuthRepo?.credentialToLogin?.provider, "google.com")
    }
}

fileprivate final class LoginCoordinator: LoginViewModel.LoginCoordinator {

    var showForgetPasswordCalled = false

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository())

    func showLogin() {
        // empty
    }
    
    func showRegister() {
        // empty
    }
    
    func showForgetPassword() {
        showForgetPasswordCalled = true
    }
    
    func showSetPassword(email: String) {
        // empty
    }
}

fileprivate final class MockAuthenticationRepository: AuthenticationRepository {

    @Published var isLoggedIn: Bool? = false

    var isLoggedInPublisher: Published<Bool?>.Publisher { $isLoggedIn }

    var currentUser: Firebase.User? { nil }

    var emailToLogin: String = ""
    var passwordToLogin: String = ""
    var credentialToLogin: AuthCredential?

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
        return GoogleAuthProvider.credential(withIDToken: "GOOGLE", accessToken: "GOOGLE")
    }
}
