//
//  ChangePasswordViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import Foundation

import XCTest
import Combine
@testable import Phraseon_InHouse
@testable import Model
@testable import Common
@testable import Domain
@testable import FirebaseStorage

final class ChangePasswordViewModelTest: XCTestCase {

    private let coordinator = ChangePasswordCoordinator()

    private let cancelBag = CancelBag()

    private var authRepo: MockAuthenticationRepository? {
        coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
    }

    lazy var viewModel: ChangePasswordViewModel = {
        return ChangePasswordViewModel(authenticationProvider: .password, coordinator: coordinator)
    }()

    func testInit() throws {

        Task {
            let viewModelApple = ChangePasswordViewModel(authenticationProvider: .apple, coordinator: coordinator)
            XCTAssertEqual(viewModelApple.state, .unavailable)

            coordinator.calledPopView = nil
            await viewModelApple.onPrimaryButtonTapped()
            XCTAssertEqual(coordinator.calledPopView, true)

            let viewModelGoogle = ChangePasswordViewModel(authenticationProvider: .google, coordinator: coordinator)
            XCTAssertEqual(viewModelGoogle.state, .unavailable)

            coordinator.calledPopView = nil
            await viewModelGoogle.onPrimaryButtonTapped()
            XCTAssertEqual(coordinator.calledPopView, true)
        }

        let viewModelPassword = ChangePasswordViewModel(authenticationProvider: .password, coordinator: coordinator)
        XCTAssertEqual(viewModelPassword.state, .currentPassword)

        XCTAssertFalse(viewModelPassword.shouldShowNewPassword)
        XCTAssertFalse(viewModelPassword.shouldShowConfirmNewPassword)
        XCTAssertFalse(viewModelPassword.shouldCurrentPasswordDisabled)
        XCTAssertTrue([viewModelPassword.newPassword, viewModelPassword.confirmNewPassword, viewModelPassword.currentPassword].allSatisfy { $0.isEmpty })
    }

    func testFlow() throws {
        let currentPassword = "current"
        viewModel.currentPassword = currentPassword
        Task {
            await viewModel.onPrimaryButtonTapped()
            XCTAssertEqual(authRepo?.enteredPassword, currentPassword)
            XCTAssertEqual(authRepo?.enteredEmail, coordinator.dependencies.authenticationRepository.email)
            XCTAssertEqual(viewModel.state, .newPassword)
            XCTAssertTrue(viewModel.shouldCurrentPasswordDisabled)
            XCTAssertTrue(viewModel.shouldShowNewPassword)
            XCTAssertFalse(viewModel.shouldShowConfirmNewPassword)
            await viewModel.onPrimaryButtonTapped()
            XCTAssertTrue(viewModel.shouldShowConfirmNewPassword)
            XCTAssertTrue(viewModel.shouldCurrentPasswordDisabled)
            await viewModel.onPrimaryButtonTapped()
            XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordTooShort)

            let newPassword = "newPassword"
            let confirmNewPassword = "newPassword"
            let expectationNewPassword = XCTestExpectation()
            let expectationConfirmNewPassword = XCTestExpectation()
            viewModel.passwordValidationHandler.$validationError.sink { error in
                if error == nil && self.viewModel.newPassword == newPassword {
                    expectationNewPassword.fulfill()
                }
                if error == nil && self.viewModel.confirmNewPassword == confirmNewPassword {
                    expectationConfirmNewPassword.fulfill()
                }
            }
            .store(in: cancelBag)

            viewModel.newPassword = newPassword
            await fulfillment(of: [expectationNewPassword], timeout: 1.0)

            await viewModel.onPrimaryButtonTapped()
            XCTAssertEqual(viewModel.passwordValidationHandler.validationError, .passwordsNotTheSame)

            viewModel.confirmNewPassword = confirmNewPassword
            await fulfillment(of: [expectationConfirmNewPassword], timeout: 1.0)

            await viewModel.onPrimaryButtonTapped()
            XCTAssertEqual(viewModel.passwordValidationHandler.validationError, nil)
            XCTAssertEqual(authRepo?.enteredUpdatedPassword, viewModel.newPassword)
            XCTAssertEqual(authRepo?.enteredUpdatedPassword, viewModel.confirmNewPassword)
            XCTAssertEqual(coordinator.calledPopView, true)
        }
    }
}

fileprivate final class ChangePasswordCoordinator: ChangePasswordViewModel.ChangePasswordCoordinator {

    var calledPopView: Bool?

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository())

    func popToRoot() {
    }
    
    func popView() {
        self.calledPopView = true
    }
}
