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

    var body: some Scene {
        WindowGroup {
            RootCoordinator.RootView()
                .tint(appColor(.paleOrange))
                .preferredColorScheme(.dark)
        }
    }
}

