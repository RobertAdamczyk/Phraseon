//
//  ProjectDetailViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI
import Combine

final class ProjectDetailViewModel: ObservableObject, ProjectMemberUseCaseProtocol, ProjectUseCaseProtocol {

    typealias ProjectDetailCoordinator = Coordinator & ProjectActions

    enum State {
        case loaded([Key])
        case searched([AlgoliaKey])
        case loading
        case failed
        case empty
        case notFound
    }

    @Published var selectedKeysOrder: KeysOrder = .alphabetically
    @Published var searchText = ""
    @Published var member: Member?
    @Published var state: State = .loading
    @Published var isSearchPresented: Bool = false

    var shouldShowContent: Bool {
        switch state {
        case .failed, .empty, .loading, .notFound: return false
        case .loaded, .searched: return true
        }
    }

    var shouldShowPicker: Bool {
        switch state {
        case .loaded: return true
        default: return false
        }
    }

    var shouldShowAddButton: Bool {
        member?.hasPermissionToAddKey == true && !isSearchPresented
    }

    var keysLimit: Int = 20

    var translationApprovalUseCase: TranslationApprovalUseCase {
        .init(project: project, subscriptionPlan: coordinator.dependencies.userDomain.user.currentValue?.subscriptionPlan)
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

    private var keys: [Key]? {
        switch state {
        case .loaded(let keys): return keys
        default: return nil
        }
    }

    private var keysTask: AnyCancellable?
    private var searchTask: AnyCancellable?

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
        if keys?.last == key && keysLimit == keys?.count {
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

    func onAlgoliaKeyTapped(_ algoliaKey: AlgoliaKey) {
        coordinator.showKeyDetails(key: algoliaKey.toKey, project: project, projectMemberUseCase: projectMemberUseCase)
    }

    private func setupSelectedKeysOrderSubscriber() {
        $selectedKeysOrder
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.setupKeysSubscriber()
            }
            .store(in: cancelBag)
    }

    private func setupSearchTextSubscriber() {
        $searchText
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: onSearchTextDidChange)
            .store(in: cancelBag)
    }

    private func setupKeysSubscriber() {
        guard let projectId = project.id else { return }
        keysTask?.cancel()
        keysTask = coordinator.dependencies.firestoreRepository.getKeysPublisher(projectId: projectId, 
                                                                                 keysOrder: selectedKeysOrder,
                                                                                 limit: keysLimit)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    DispatchQueue.main.async {
                        self?.state = .failed
                    }
                }
            } receiveValue: { [weak self] keys in
                DispatchQueue.main.async {
                    if keys.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .loaded(keys)
                    }
                }
            }
    }

    private func setLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .loading
        }
    }

    private func onSearchTextDidChange(_ text: String) {
        searchTask?.cancel()
        guard !text.isEmpty && text.count > 2 && keys?.isEmpty != true else {
            setupKeysSubscriber()
            return
        }
        setLoading()
        searchTask = Just(())
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] in
                self?.searchKeys(with: text)
            })
    }

    private func searchKeys(with text: String) {
        guard let projectId = project.id else { return }
        coordinator.dependencies.searchRepository.searchKeys(in: projectId, with: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let keys):
                    if keys.isEmpty {
                        self?.state = .notFound
                    } else {
                        self?.state = .searched(keys)
                    }
                case .failure:
                    self?.state = .failed
                }
            }
        }
    }
}
