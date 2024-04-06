//
//  RegisterViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 22.02.24.
//

import XCTest
import Common

final class RegisterViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

    func testInit() throws {
        let coordinator: RegisterCoordinator = .init()
        let viewModel: RegisterViewModel = .init(coordinator: coordinator)

        XCTAssertEqual(viewModel.email, "")
        XCTAssertFalse(viewModel.shouldShowActivityView)
    }

    func testOnLoginTapped() throws {
        let coordinator: RegisterCoordinator = .init()
        let viewModel: RegisterViewModel = .init(coordinator: coordinator)

        viewModel.onLoginTapped()
        XCTAssertTrue(coordinator.showLoginCalled)
    }

    func testOnRegisterWithEmailTapped() throws {
        let coordinator: RegisterCoordinator = .init()
        let viewModel: RegisterViewModel = .init(coordinator: coordinator)

        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .empty)

        viewModel.email = "TEST123"
        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)

        XCTAssertFalse(coordinator.showSetPasswordCalled)

        viewModel.email = "TEST123@GMAIL"
        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)

        XCTAssertFalse(coordinator.showSetPasswordCalled)

        viewModel.email = "TEST123GMAIL.COM"
        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)

        XCTAssertFalse(coordinator.showSetPasswordCalled)

        viewModel.email = "TEST123@GMAIL.COM"
        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, nil)

        XCTAssertTrue(coordinator.showSetPasswordCalled)
        XCTAssertEqual(coordinator.passedEmail, "TEST123@GMAIL.COM")
    }

    func testResetValidationErrorOnTextChange() throws {
        let coordinator: RegisterCoordinator = .init()
        let viewModel: RegisterViewModel = .init(coordinator: coordinator)

        viewModel.onRegisterWithEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .empty)

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        viewModel.emailValidationHandler.$validationError.sink { error in
            if error == nil {
                expectation.fulfill()
            }
        }
        .store(in: cancelBag)

        viewModel.email = "NEW"

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.emailValidationHandler.validationError, nil)
    }

    @MainActor
    func testOnLoginWithGoogleTapped() throws {
        let coordinator: RegisterCoordinator = .init()
        let viewModel: RegisterViewModel = .init(coordinator: coordinator)
        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        mockAuthRepo?.$credentialToLogin.sink(receiveValue: { credential in
            if credential != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        viewModel.onLoginWithGoogleTapped()

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(mockAuthRepo?.credentialToLogin?.provider, "google.com")
    }
}

fileprivate final class RegisterCoordinator: RegisterViewModel.RegisterCoordinator {

    var showLoginCalled: Bool = false
    var showSetPasswordCalled: Bool = false
    var passedEmail: String = ""

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository())

    func showLogin() {
        showLoginCalled = true
    }

    func showRegister() { }

    func showForgetPassword() { }

    func showSetPassword(email: String) {
        passedEmail = email
        showSetPasswordCalled = true
    }
}
