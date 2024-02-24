//
//  SetPasswordViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 23.02.24.
//

import XCTest
@testable import Phraseon_InHouse

final class SetPasswordViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

    func testInit() throws {
        let coordinator: SetPasswordCoordinator = .init()
        let viewModel: SetPasswordViewModel = .init(email: "EMAIL@GOOGLE.COM", coordinator: coordinator)

        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.confirmPassword, "")
    }

    @MainActor
    func testOnCreateAccountTapped() async throws {
        let coordinator: SetPasswordCoordinator = .init()
        let initEmail = "EMAIL@GOOGLE.COM"
        let viewModel: SetPasswordViewModel = .init(email: initEmail, coordinator: coordinator)

        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordTooShort)
        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
        XCTAssertEqual(mockAuthRepo?.email, nil)
        XCTAssertEqual(mockAuthRepo?.password, nil)

        viewModel.password = "1234567"
        viewModel.confirmPassword = "1234567"
        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordTooShort)
        XCTAssertEqual(mockAuthRepo?.email, nil)
        XCTAssertEqual(mockAuthRepo?.password, nil)

        viewModel.password = "1234567"
        viewModel.confirmPassword = "12345678"
        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordsNotTheSame)
        XCTAssertEqual(mockAuthRepo?.email, nil)
        XCTAssertEqual(mockAuthRepo?.password, nil)

        viewModel.password = "12345678"
        viewModel.confirmPassword = "12345678"
        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, nil)
        XCTAssertEqual(mockAuthRepo?.email, initEmail)
        XCTAssertEqual(mockAuthRepo?.password, "12345678")
    }

    @MainActor
    func testResetValidationErrorOnTextChange() async throws {
        let coordinator: SetPasswordCoordinator = .init()
        let viewModel: SetPasswordViewModel = .init(email: "EMAIL@GOOGLE.COM", coordinator: coordinator)

        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordTooShort)

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        viewModel.passwordValidationHandler.$validationError.sink { error in
            if error == nil {
                expectation.fulfill()
            }
        }
        .store(in: cancelBag)

        viewModel.password = "NEW"

        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, nil)

        await viewModel.onCreateAccountTapped()
        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordsNotTheSame)

        let expectation2 = XCTestExpectation(description: "Wait for 1 second")
        viewModel.passwordValidationHandler.$validationError.sink { error in
            if error == nil {
                expectation2.fulfill()
            }
        }
        .store(in: cancelBag)

        viewModel.confirmPassword = "NEW"
        await fulfillment(of: [expectation2], timeout: 1.0)

        XCTAssertEqual(viewModel.passwordValidationHandler.validationError, nil)
    }
}

fileprivate final class SetPasswordCoordinator: SetPasswordViewModel.SetPasswordCoordinator {

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository())
}

