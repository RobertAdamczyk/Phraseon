//
//  ForgetPasswordViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 22.02.24.
//

import XCTest
@testable import Phraseon_InHouse

final class ForgetPasswordViewModelTest: XCTestCase {

    func testInit() throws {
        let coordinator: ForgetPasswordCoordinator = .init()
        let viewModel: ForgetPasswordViewModel = .init(coordinator: coordinator)

        XCTAssertEqual(viewModel.email, "")
    }

    @MainActor
    func testOnSendEmailTapped() async throws {
        let coordinator: ForgetPasswordCoordinator = .init()
        let viewModel: ForgetPasswordViewModel = .init(coordinator: coordinator)

        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .empty)
        XCTAssertFalse(coordinator.popViewCalled)

        viewModel.email = "TEST123"
        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)
        XCTAssertFalse(coordinator.popViewCalled)

        viewModel.email = "TEST123@GMAIL"
        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)
        XCTAssertFalse(coordinator.popViewCalled)

        viewModel.email = "TEST123GMAIL.COM"
        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .badlyFormatted)
        XCTAssertFalse(coordinator.popViewCalled)

        viewModel.email = "TEST123@GMAIL.COM"
        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, nil)

        let mockAuthRepo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
        XCTAssertEqual(mockAuthRepo?.email, "TEST123@GMAIL.COM")
        XCTAssertTrue(coordinator.popViewCalled)
    }

    @MainActor
    func testResetValidationErrorOnTextChange() async throws {
        let coordinator: ForgetPasswordCoordinator = .init()
        let viewModel: ForgetPasswordViewModel = .init(coordinator: coordinator)

        await viewModel.onSendEmailTapped()
        XCTAssertEqual(viewModel.emailValidationHandler.validationError, .empty)

        viewModel.email = "NEW"

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in // TODO: Try sink on validationerror
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.emailValidationHandler.validationError, nil)
    }
}

fileprivate final class ForgetPasswordCoordinator: ForgetPasswordViewModel.ForgetPasswordCoordinator {

    var popViewCalled: Bool = false

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository())

    func popToRoot() {}
    
    func popView() {
        popViewCalled = true
    }
}
