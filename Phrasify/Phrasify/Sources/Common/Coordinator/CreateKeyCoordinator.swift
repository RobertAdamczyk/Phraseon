//
//  CreateKeyCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

final class CreateKeyCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & RootActions

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension CreateKeyCoordinator: CreateKeyActions {

    func dismiss() {
        parentCoordinator.dismissFullScreenCover()
    }

    func popToRoot() {
        navigationViews.removeAll()
    }
}

extension CreateKeyCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case empty

        static func == (lhs: CreateKeyCoordinator.NavigationView, rhs: CreateKeyCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .empty: return "001"
            }
        }
    }
}
