//
//  AppDelegate.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import FirebaseCore
import SwiftUI
import GoogleSignIn
import Glassfy

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Glassfy.initialize(apiKey: "32a1f81429ab4cfd9ac7660573e4b45f", watcherMode: false)
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
