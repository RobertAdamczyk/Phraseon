//
//  ProjectDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI
import Combine

final class ProjectDetailViewModel: ObservableObject, ProjectMemberUseCaseProtocol, ProjectUseCaseProtocol {

    typealias ProjectDetailCoordinator = Coordinator & ProjectActions

    @Published var selectedKeysOrder: KeysOrder = .alphabetically
    @Published var searchText = ""
    @Published var member: Member?
    @Published private var keys: [Key] = []

    var searchKeys: [Key] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { key in
                key.id?.lowercased().contains(searchText.lowercased()) == true
            }
        }
    }

    var keysLimit: Int = 20

    var translationApprovalUseCase: TranslationApprovalUseCase {
        .init(project: project, subscriptionPlan: coordinator.dependencies.userDomain.user?.subscriptionPlan)
    }

    internal lazy var projectUseCase: ProjectUseCase = {
        .init(firestoreRepository: coordinator.dependencies.firestoreRepository, project: project)
    }()

    internal lazy var projectMemberUseCase: ProjectMemberUseCase = {
        .init(firestoreRepository: coordinator.dependencies.firestoreRepository,
              authenticationRepository: coordinator.dependencies.authenticationRepository,
              project: project)
    }()

    internal var project: Project
    internal let cancelBag = CancelBag()
    private var keysTask: AnyCancellable?

    private let coordinator: ProjectDetailCoordinator

    init(coordinator: ProjectDetailCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        setupKeysSubscriber()
        setupSelectedKeysOrderSubscriber()
        setupMemberSubscriber()
        setupProjectSubscriber()
        setupSearchTextSubscriber()
    }

    func onKeyAppear(_ key: Key) {
        if keys.last == key && keysLimit == keys.count {
            keysLimit += 10
            setupKeysSubscriber()
        }
    }

    func onAddButtonTapped() {
        coordinator.presentCreateKey(project: project)
    }

    func onSettingsTapped() {
        coordinator.showProjectSettings(projectUseCase: projectUseCase, projectMemberUseCase: projectMemberUseCase)
    }

    func onKeyTapped(_ key: Key) {
        coordinator.showKeyDetails(key: key, project: project, projectMemberUseCase: projectMemberUseCase)
    }

    private func setupSelectedKeysOrderSubscriber() {
        $selectedKeysOrder
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedKeysOrder in
                self?.setupKeysSubscriber()
            }
            .store(in: cancelBag)
    }

    private func setupSearchTextSubscriber() {
        $searchText
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.onSearchTextDidChange()
            }
            .store(in: cancelBag)
    }

    private func setupKeysSubscriber() {
        guard let projectId = project.id else { return }
        keysTask?.cancel()
        keysTask = coordinator.dependencies.firestoreRepository.getKeysPublisher(projectId: projectId, 
                                                                                 keysOrder: selectedKeysOrder,
                                                                                 limit: keysLimit)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] keys in
                DispatchQueue.main.async {
                    self?.keys = keys
                }
            }
    }

    private func onSearchTextDidChange() {
        print("TEST: CHANGE")
    }

    private func searchKeys(with text: String) {
        guard let projectId = project.id else { return }
        coordinator.dependencies.searchRepository.searchKeys(in: projectId, with: searchText) { result in
            print(result)
        }
    }
}
