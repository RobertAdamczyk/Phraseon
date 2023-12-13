//
//  RootCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI

final class RootCoordinator: ObservableObject, Coordinator {

    var dependencies: Dependencies

    func createRootView() -> AnyView {
        let coordinator: StartCoordinator = .init(parentCoordinator: self)
        if Bool.random() {
            return .init(coordinator.createRootView())
        } else {
            return .init(Text("isLoggedIn-Home"))
        }

    }

    init() {
        dependencies = .init(repository: "")
    }

}
