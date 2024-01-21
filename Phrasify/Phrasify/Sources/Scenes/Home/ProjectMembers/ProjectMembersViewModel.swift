//
//  ProjectMembersViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

final class ProjectMembersViewModel: ObservableObject, ProjectMemberUseCaseProtocol {

    typealias ProjectMembersCoordinator = Coordinator & ProjectActions & SelectMemberRoleActions

    @Published var members: [Member] = []
    @Published var member: Member?

    var groupedMembers: [Role: [Member]] {
        Dictionary(grouping: members, by: { $0.role })
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            coordinator.showDeleteMemberWarning(project: project, member: member)
        }
    }

    func onMemberEdit(_ member: Member) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            coordinator.showSelectMemberRole(member: member, project: project)
        }
    }

    private func setupMembersSubscriber() {
        guard let projectId = project.id else { return }
        coordinator.dependencies.firestoreRepository.getMembersPublisher(projectId: projectId)
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure = completion {
                    ToastView.showGeneralError()
                }
            } receiveValue: { [weak self] members in
                DispatchQueue.main.async {
                    self?.members = members.sorted(by: { $0.role.sortIndex < $1.role.sortIndex })
                }
            }
            .store(in: cancelBag)
    }
}


