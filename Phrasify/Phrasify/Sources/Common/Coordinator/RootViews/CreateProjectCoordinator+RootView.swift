//
//  CreateProjectCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

extension CreateProjectCoordinator {

    struct RootView: View {

        @StateObject private var coordinator: CreateProjectCoordinator

        init(parentCoordinator: CreateProjectCoordinator.ParentCoordinator) {
            self._coordinator = .init(wrappedValue: .init(parentCoordinator: parentCoordinator))
        }

        var body: some View {
            NavigationStack(path: $coordinator.navigationViews) {
                CreateProjectView(coordinator: coordinator)
                    .navigationDestination(for: CreateProjectCoordinator.NavigationView.self) {
                        switch $0 {
                        case .selectLanguage(let viewModel): SelectLanguageView(viewModel: viewModel)
                        case .selectTechnology(let viewModel): SelectTechnologyView(viewModel: viewModel)
                        case .selectBaseLanguage(let viewModel): SelectBaseLanguageView(viewModel: viewModel)
                        }
                    }
            }
            .fullScreenCover(item: $coordinator.presentedFullScreenCover) {
                switch $0 {
                case .paywall: PaywallCoordinator.RootView(parentCoordinator: coordinator)
                }
            }
            .onDisappear(perform: coordinator.popToRoot)
        }
    }
}
