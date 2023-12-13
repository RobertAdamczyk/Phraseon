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

import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct PhrasifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject private var rootCoordinator: RootCoordinator = .init()

    var body: some Scene {
        WindowGroup {
            rootCoordinator.createRootView()
                .tint(appColor(.paleOrange))
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
