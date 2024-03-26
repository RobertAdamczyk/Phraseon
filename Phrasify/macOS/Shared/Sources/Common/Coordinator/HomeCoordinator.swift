//
//  HomeCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.03.24.
//

import SwiftUI

final class HomeCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension HomeCoordinator: HomeActions {

    func showProjectDetail() {
        navigationViews.append(.empty)
    }
}

extension HomeCoordinator {

    enum NavigationView {
        case empty
    }
}
