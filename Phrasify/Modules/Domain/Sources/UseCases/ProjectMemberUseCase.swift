//
//  ProjectMemberUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import Model
import Common

public protocol ProjectMemberUseCaseProtocol: AnyObject {

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

    public var isAdmin: Bool {
        [Role.admin].contains(member?.role)
    }

    public var isOwner: Bool {
        [Role.owner].contains(member?.role)
    }

    public var isDeveloper: Bool {
        [Role.developer].contains(member?.role)
    }

    public var isViewer: Bool {
        [Role.viewer].contains(member?.role)
    }

    public func setupMemberSubscriber() {
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

public final class ProjectMemberUseCase {

    @Published public private(set) var member: Member?

    private let firestoreRepository: FirestoreRepository
    private let authenticationRepository: AuthenticationRepository
    private let project: Project

    private let cancelBag = CancelBag()

    public init(firestoreRepository: FirestoreRepository, authenticationRepository: AuthenticationRepository, project: Project) {
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
