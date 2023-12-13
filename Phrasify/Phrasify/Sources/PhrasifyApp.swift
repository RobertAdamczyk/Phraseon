//
//  PhrasifyApp.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

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

