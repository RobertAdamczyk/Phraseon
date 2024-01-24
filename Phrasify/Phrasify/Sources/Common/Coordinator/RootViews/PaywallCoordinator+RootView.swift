//
//  PaywallCoordinator+RootView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI

extension PaywallCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: PaywallCoordinator

        init(parentCoordinator: PaywallCoordinator.ParentCoordinator) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                PaywallView(coordinator: coordinator)
                    .navigationDestination(for: PaywallCoordinator.NavigationView.self) {
                        switch $0 {
                        case .empty: Text("XD")
                        }
                    }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
