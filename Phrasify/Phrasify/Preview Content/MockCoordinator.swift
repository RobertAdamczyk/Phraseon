//
//  MockCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

#if DEBUG

final class MockCoordinator: Coordinator, StartActions, RootActions, CreateProjectActions {

    var dependencies: Dependencies = .init(authenticationRepository: .init(), firestoreRepository: .init(), cloudRepository: .init())

    func showLogin() { /*empty*/ }

    func showRegister() { /*empty*/ }

    func showForgetPassword() { /*empty*/ }

    func showSetPassword(email: String) { /*empty*/ }

    func closeForgetPassword() { /*empty*/ }

    func popToRoot() { /*empty*/ }

    func showProfile() { /*empty*/ }
    func presentCreateProject() { /*empty*/ }
    func presentCreateKey(project: Project) { /*empty*/ }
    func dismissFullScreenCover() { /*empty*/ }
    func showProjectDetails(project: Project) { /*empty*/ }
    func showSelectLanguage(name: String) { /*empty*/ }
    func showSelectTechnology(name: String, languages: [Language]) { /*empty*/ }
    func dismiss() { /*empty*/ }
}

#endif
