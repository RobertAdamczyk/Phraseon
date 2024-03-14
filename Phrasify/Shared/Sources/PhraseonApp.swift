//
//  Phraseon_InHouse_MacOSApp.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 12.03.24.
//

import SwiftUI
import Common
import FirebaseCore
import GoogleSignIn

@main
struct PhraseonApp: App {

    init() {
        guard let target = Target(rawValue: Bundle.main.bundleURL.lastPathComponent) else { fatalError("Target not found !") }
        TargetConfiguration.shared.setup(target: target)
        Secrets.shared.setup(path: Bundle.main.path(forResource: "secrets", ofType: "json"))
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootCoordinator.RootView()
                .tint(appColor(.paleOrange))
                .preferredColorScheme(.dark)
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url)
                })
        }
    }
}
