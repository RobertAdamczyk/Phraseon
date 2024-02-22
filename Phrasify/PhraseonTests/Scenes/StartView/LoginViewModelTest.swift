//
//  LoginViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 21.02.24.
//

import XCTest
@testable import Phraseon_InHouse

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
