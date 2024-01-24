//
//  PaywallCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI

final class PaywallCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & RootActions & FullScreenCoverActions

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension PaywallCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension PaywallCoordinator: FullScreenCoverActions {

    func dismissFullScreenCover() {
        parentCoordinator.dismissFullScreenCover()
    }
}

extension PaywallCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case empty(viewModel: Int)

        static func == (lhs: PaywallCoordinator.NavigationView, rhs: PaywallCoordinator.NavigationView) -> Bool {
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
