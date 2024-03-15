//
//  StartCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

final class StartCoordinator: ObservableObject, Coordinator {

    typealias ParentCoordinator = Coordinator

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }

    enum NavigationView {

        case empty
    }
}

extension StartCoordinator: StartActions {
    func showEmpty() {
        navigationViews.append(.empty)
    }
}
