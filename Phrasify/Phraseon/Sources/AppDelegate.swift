//
//  AppDelegate.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import FirebaseCore
import SwiftUI
import GoogleSignIn
import Model

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard let target = Target(rawValue: Bundle.main.bundleURL.lastPathComponent) else { fatalError("Target not found !") }
        TargetConfiguration.shared.setup(target: target)
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
