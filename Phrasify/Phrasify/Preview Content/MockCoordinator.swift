//
//  MockCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

#if DEBUG

final class MockCoordinator: Coordinator, StartActions {

    var dependencies: Dependencies = .init(authenticationRepository: .init())

    func createRootView() -> AnyView {
        .init(EmptyView())
    }

    func showLogin() { /*empty*/ }

    func showRegister() { /*empty*/ }

    func showForgetPassword() { /*empty*/ }

    func showSetPassword() { /*empty*/ }

    func closeForgetPassword() { /*empty*/ }

    func popToRoot() { /*empty*/ }
}

#endif
