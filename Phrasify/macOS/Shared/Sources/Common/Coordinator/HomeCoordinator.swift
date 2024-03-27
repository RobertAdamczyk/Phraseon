//
//  HomeCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.03.24.
//

import SwiftUI

final class HomeCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var selectedMenuItem: MenuItem = .projects

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension HomeCoordinator: MenuActions {

    func showProjects() {
        self.selectedMenuItem = .projects
    }

    func showProfile() {
        self.selectedMenuItem = .profile
    }
}
