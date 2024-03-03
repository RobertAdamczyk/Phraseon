//
//  LoginViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 21.02.24.
//

import XCTest
@testable import Phraseon_InHouse
@testable import Common

final class LoginViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

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
        XCTAssertEqual(mockAuthRepo?.enteredEmail, "EMAIL_TEST")
        XCTAssertEqual(mockAuthRepo?.enteredPassword, "PASSWORD_TEST")
    }

    @MainActor
    func testOnLoginWithGoogleTapped() throws {
        let coordinator: LoginCoordinator = .init()
        let viewModel: LoginViewModel = .init(coordinator: coordinator)
        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        mockAuthRepo?.$credentialToLogin.sink(receiveValue: { credential in
            if credential != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        viewModel.onLoginWithGoogleTapped()

        wait(for: [expectation], timeout: 1.0)

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
