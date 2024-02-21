//
//  LoginViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 21.02.24.
//

import XCTest
@testable import Phraseon_InHouse

final class LoginViewModelTest: XCTestCase {

}

fileprivate final class LoginCoordinator: LoginViewModel.LoginCoordinator {

    var dependencies: Dependencies = MockDependencies.dependencies

    func showLogin() {
        // empty
    }
    
    func showRegister() {
        // empty
    }
    
    func showForgetPassword() {
        // empty
    }
    
    func showSetPassword(email: String) {
        // empty
    }
}
