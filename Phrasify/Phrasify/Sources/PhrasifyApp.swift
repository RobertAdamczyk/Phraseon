//
//  PhrasifyApp.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

struct Dependencies { // TODO: Make done
    var repository: String
}

protocol Coordinator: AnyObject {

    var dependencies: Dependencies { get }

    func createRootView() -> AnyView
}

@main
struct PhrasifyApp: App {

    @StateObject private var rootCoordinator: RootCoordinator = .init()

    var body: some Scene {
        WindowGroup {
            rootCoordinator.createRootView()
        }
    }
}

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
