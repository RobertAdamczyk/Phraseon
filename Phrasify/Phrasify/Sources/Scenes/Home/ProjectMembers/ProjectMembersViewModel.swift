//
//  ProjectMembersViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

final class ProjectMembersViewModel: ObservableObject, ProjectMemberProtocol {

    typealias ProjectMembersCoordinator = Coordinator & ProjectActions

    @Published var members: [Member] = []
    @Published var member: Member?

    var groupedMembers: [Role: [Member]] {
        Dictionary(grouping: members, by: { $0.role })
    }

    var hasPermissionToManage: Bool {
        isAdmin || isOwner
    }

    private let project: Project
    private let coordinator: ProjectMembersCoordinator
    internal let cancelBag = CancelBag()
    internal let projectMemberUseCase: ProjectMemberUseCase

    init(coordinator: ProjectMembersCoordinator, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        self.coordinator = coordinator
        self.project = project
        self.projectMemberUseCase = projectMemberUseCase
        setupMembersSubscriber()
        setupMemberSubscriber()
    }

    func onInviteMemberTapped() {
        coordinator.presentInviteMember(project: project)
    }

    func onMemberDelete(_ member: Member) {

    }

    func onMemberEdit(_ member: Member) {

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


