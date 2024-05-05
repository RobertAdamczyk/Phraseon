//
//  RootCoordinator+RootView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator = RootCoordinator()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    HomeCoordinator.RootView(coordinator: rootCoordinator)
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(coordinator: rootCoordinator)
                }
                if let updateInfo = rootCoordinator.updateInfo {
                    AppUpdateView(title: updateInfo.title,
                                  message: updateInfo.message,
                                  confirmButtonText: updateInfo.confirmButtonText,
                                  url: updateInfo.url)
                }
            }
        }
    }
}
