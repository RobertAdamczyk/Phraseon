//
//  InviteMemberCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 22.04.24.
//

import SwiftUI
import Model

final class InviteMemberCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator & SheetActions

    @Published var navigationViews: [NavigationView] = []

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension InviteMemberCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension InviteMemberCoordinator: SheetActions {

    func dismissSheet() {
        parentCoordinator.dismissSheet()
    }
}

extension InviteMemberCoordinator: SelectMemberRoleActions {

    func showSelectMemberRole(email: String, project: Project, user: User) {
        let viewModel = SelectMemberRoleViewModel(coordinator: self, project: project, context: .invite(user: user))
        let view: NavigationView = .selectMemberRole(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectMemberRole(member: Member, project: Project) {
        // empty implementation
    }
}

extension InviteMemberCoordinator {

    enum NavigationView: Identifiable, Equatable, Hashable {

        case selectMemberRole(viewModel: SelectMemberRoleViewModel)

        static func == (lhs: InviteMemberCoordinator.NavigationView, rhs: InviteMemberCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .selectMemberRole: return "001"
            }
        }
    }
}

