//
//  HomeCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.03.24.
//

import SwiftUI

final class HomeCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var selectedSplitView: SplitView = .home

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension HomeCoordinator: MenuActions {

    func showHome() {
        self.selectedSplitView = .home
    }

    func showProfile() {
        self.selectedSplitView = .profile
    }
}

extension HomeCoordinator {

    enum SplitView {
        case home
        case profile
    }
}
