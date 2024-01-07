//
//  InviteMemberViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class InviteMemberViewModel: ObservableObject {

    typealias InviteMemberCoordinator = Coordinator & FullScreenCoverActions

    @Published var email: String = ""

    private let project: Project
    private let coordinator: InviteMemberCoordinator

    init(coordinator: InviteMemberCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onContinueTapped() {

    }

    func onCloseButtonTapped() {
        coordinator.dismissFullScreenCover()
    }
}
