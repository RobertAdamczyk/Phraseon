//
//  RootCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject, Coordinator {

    var dependencies: Dependencies

    private var cancelBag = CancelBag()

    func createRootView() -> AnyView {
        let startCoordinator: StartCoordinator = .init(parentCoordinator: self)
        if dependencies.authenticationRepository.isLoggedIn == true {
            return .init(Text("XD"))
        } else {
            return .init(startCoordinator.createRootView())
        }
    }

    init() {
        dependencies = .init(authenticationRepository: .init())
        setupLoginSubscription()
    }

    private func setupLoginSubscription() {
        dependencies.authenticationRepository.$isLoggedIn.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: cancelBag)
    }
}
