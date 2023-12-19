//
//  MockCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

#if DEBUG

final class MockCoordinator: Coordinator, StartActions, RootActions {

    var dependencies: Dependencies = .init(authenticationRepository: .init())

    func showLogin() { /*empty*/ }

    func showRegister() { /*empty*/ }

    func showForgetPassword() { /*empty*/ }

    func showSetPassword(email: String) { /*empty*/ }

    func closeForgetPassword() { /*empty*/ }

    func popToRoot() { /*empty*/ }

    func showProfile() { /*empty*/ }
    func showNewProject() { /*empty*/ }
    func showProjectDetails() { /*empty*/ }
}

#endif
