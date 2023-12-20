//
//  MockCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

#if DEBUG

final class MockCoordinator: Coordinator, StartActions, RootActions, NewProjectActions {

    var dependencies: Dependencies = .init(authenticationRepository: .init())

    func showLogin() { /*empty*/ }

    func showRegister() { /*empty*/ }

    func showForgetPassword() { /*empty*/ }

    func showSetPassword(email: String) { /*empty*/ }

    func closeForgetPassword() { /*empty*/ }

    func popToRoot() { /*empty*/ }

    func showProfile() { /*empty*/ }
    func presentNewProject() { /*empty*/ }
    func dismissFullScreenCover() { /*empty*/ }
    func showProjectDetails() { /*empty*/ }
    func showSelectLanguage() { /*empty*/ }
    func showSelectTechnology() { /*empty*/ }
    func dismiss() { /*empty*/ }

}

#endif
