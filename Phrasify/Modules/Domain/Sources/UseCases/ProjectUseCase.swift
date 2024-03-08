//
//  ProjectUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.01.24.
//

import SwiftUI
import Model
import Common

public protocol ProjectUseCaseProtocol: AnyObject {

    var project: Project { set get }
    var projectUseCase: ProjectUseCase { get }
    var cancelBag: CancelBag { get }

    func setupProjectSubscriber()
}

extension ProjectUseCaseProtocol {

    public func setupProjectSubscriber() {
        projectUseCase.$project
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] project in
                DispatchQueue.main.async {
                    self?.project = project
                }
            })
            .store(in: cancelBag)
    }
}

public final class ProjectUseCase {

    @Published public private(set) var project: Project

    private let firestoreRepository: FirestoreRepository

    private let cancelBag = CancelBag()

    public init(firestoreRepository: FirestoreRepository, project: Project) {
        self.firestoreRepository = firestoreRepository
        self.project = project
        setupProjectSubscriber()
    }

    private func setupProjectSubscriber() {
        guard let projectId = project.id else { return }
        firestoreRepository.getProjectPublisher(projectId: projectId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implemenation
            } receiveValue: { [weak self] project in
                guard let project else { return }
                DispatchQueue.main.async {
                    self?.project = project
                }
            }
            .store(in: cancelBag)
    }
}

