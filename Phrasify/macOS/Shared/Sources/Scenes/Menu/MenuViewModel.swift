//
//  MenuViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI
import Common

final class MenuViewModel: ObservableObject {

    typealias MenuCoordinator = Coordinator & MenuActions

    @Published private(set) var selectedMenuItem: MenuItem

    private let coordinator: MenuCoordinator

    init(coordinator: MenuCoordinator) {
        self.selectedMenuItem = (coordinator as? HomeCoordinator)?.selectedMenuItem ?? .projects
        self.coordinator = coordinator
        setupMenuItemSubscription()
    }

    func onProjectsTapped() {
        coordinator.showProjects()
    }

    func onProfileTapped() {
        coordinator.showProfile()
    }

    private func setupMenuItemSubscription() {
        (coordinator as? HomeCoordinator)?.$selectedMenuItem.assign(to: &$selectedMenuItem)
    }
}


