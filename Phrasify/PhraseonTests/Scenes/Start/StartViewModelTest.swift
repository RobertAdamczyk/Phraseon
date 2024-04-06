//
//  StartViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 20.02.24.
//

import XCTest

final class StartViewModelTest: XCTestCase {

    func testShowLogin() throws {
        let coordinator = StartCoordinator()
        let startViewModel: StartViewModel = .init(coordinator: coordinator)
        XCTAssertFalse(coordinator.showLoginCalled, "should be false on init")
        startViewModel.onSignInTapped()
        XCTAssertTrue(coordinator.showLoginCalled, "should be called")
    }

    func testShowRegister() throws {
        let coordinator = StartCoordinator()
        let startViewModel: StartViewModel = .init(coordinator: coordinator)
        XCTAssertFalse(coordinator.showRegisterCalled, "should be false on init")
        startViewModel.onSignUpTapped()
        XCTAssertTrue(coordinator.showRegisterCalled, "should be called")
    }
}

fileprivate final class StartCoordinator: StartViewModel.StartCoordinator {

    var showLoginCalled: Bool = false
    var showRegisterCalled: Bool = false

    var dependencies: Dependencies = MockDependencies.dependencies

    func showLogin() {
        showLoginCalled = true
    }

    func showRegister() {
        showRegisterCalled = true
    }

    func showForgetPassword() {
        // empty
    }

    func showSetPassword(email: String) {
        // empty
    }
}
