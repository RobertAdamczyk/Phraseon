//
//  ProjectMembersViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

final class ProjectMembersViewModel: ObservableObject {

    typealias ProjectMembersCoordinator = Coordinator & ProjectActions

    @Published var members: [Member] = []

    private let project: Project
    private let coordinator: ProjectMembersCoordinator
    private let cancelBag = CancelBag()

    init(coordinator: ProjectMembersCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupMembersSubscriber()
    }

    func onInviteMemberTapped() {
        coordinator.presentInviteMember(project: project)
    }

    private func setupMembersSubscriber() {
        guard let projectId = project.id else { return }
        coordinator.dependencies.firestoreRepository.getMembersPublisher(projectId: projectId)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] members in
                DispatchQueue.main.async {
                    self?.members = members.sorted(by: { $0.role.sortIndex < $1.role.sortIndex })
                }
            })
            .store(in: cancelBag)
    }
}


