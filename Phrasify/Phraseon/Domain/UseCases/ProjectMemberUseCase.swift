//
//  ProjectMemberUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import Model

protocol ProjectMemberUseCaseProtocol: AnyObject {

    var member: Member? { set get }
    var projectMemberUseCase: ProjectMemberUseCase { get }
    var cancelBag: CancelBag { get }
    var isAdmin: Bool { get }
    var isOwner: Bool { get }
    var isDeveloper: Bool { get }
    var isViewer: Bool { get }

    func setupMemberSubscriber()
}

extension ProjectMemberUseCaseProtocol {

    var isAdmin: Bool {
        [Role.admin].contains(member?.role)
    }

    var isOwner: Bool {
        [Role.owner].contains(member?.role)
    }

    var isDeveloper: Bool {
        [Role.developer].contains(member?.role)
    }

    var isViewer: Bool {
        [Role.viewer].contains(member?.role)
    }

    func setupMemberSubscriber() {
        projectMemberUseCase.$member
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] member in
                DispatchQueue.main.async {
                    self?.member = member
                }
            })
            .store(in: cancelBag)
    }
}

final class ProjectMemberUseCase {

    @Published private(set) var member: Member?

    private let firestoreRepository: FirestoreRepository
    private let authenticationRepository: AuthenticationRepository
    private let project: Project

    private let cancelBag = CancelBag()

    init(firestoreRepository: FirestoreRepository, authenticationRepository: AuthenticationRepository, project: Project) {
        self.firestoreRepository = firestoreRepository
        self.authenticationRepository = authenticationRepository
        self.project = project
        setupMemberSubscriber()
    }

    private func setupMemberSubscriber() {
        guard let projectId = project.id, let userId = authenticationRepository.userId else { return }
        firestoreRepository.getMemberPublisher(userId: userId, projectId: projectId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] member in
                self?.member = member
            }
            .store(in: cancelBag)
    }
}
