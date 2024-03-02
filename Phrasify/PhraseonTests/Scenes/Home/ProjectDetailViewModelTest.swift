//
//  ProjectDetailViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 24.02.24.
//

import XCTest
import Combine
@testable import Phraseon_InHouse
@testable import Model

final class ProjectDetailViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

    static var project: Project = .init(id: "123", name: "", technologies: [], languages: [], baseLanguage: .english, 
                                        members: [], owner: "",
                                        securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: "")

    func testInit() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        XCTAssertEqual(viewModel.selectedKeysOrder, .alphabetically)
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.isSearchPresented, false)
        XCTAssertEqual(viewModel.keysLimit, 20)
    }

    func testShouldShowContent() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        viewModel.state = .empty
        XCTAssertFalse(viewModel.shouldShowContent)

        viewModel.state = .failed
        XCTAssertFalse(viewModel.shouldShowContent)

        viewModel.state = .notFound
        XCTAssertFalse(viewModel.shouldShowContent)

        viewModel.state = .loading
        XCTAssertFalse(viewModel.shouldShowContent)

        viewModel.state = .searched([])
        XCTAssertTrue(viewModel.shouldShowContent)

        viewModel.state = .loaded([])
        XCTAssertTrue(viewModel.shouldShowContent)
    }

    func testShouldShowPicker() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        viewModel.state = .empty
        XCTAssertFalse(viewModel.shouldShowPicker)

        viewModel.state = .failed
        XCTAssertFalse(viewModel.shouldShowPicker)

        viewModel.state = .notFound
        XCTAssertFalse(viewModel.shouldShowPicker)

        viewModel.state = .loading
        XCTAssertFalse(viewModel.shouldShowPicker)

        viewModel.state = .searched([])
        XCTAssertFalse(viewModel.shouldShowPicker)

        viewModel.state = .loaded([])
        XCTAssertTrue(viewModel.shouldShowPicker)
    }

    func testProjectMemberUseCase() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        XCTAssertEqual(viewModel.member, nil)

        let expectation = XCTestExpectation(description: "Wait for member")
        viewModel.$member.sink(receiveValue: { member in
            if member != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 1.0)

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        XCTAssertEqual(viewModel.member, repo?.member)
        XCTAssertNotEqual(viewModel.member, nil)
    }

    func testShouldShowAddButton() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        var members: [String: Member] = [:]

        Role.allCases.forEach { role in
            members.updateValue(.init(role: role, name: "", surname: "", email: ""), forKey: role.title)
        }

        XCTAssertEqual(members.count, 5)

        viewModel.member = members[Role.admin.title]
        XCTAssertEqual(viewModel.shouldShowAddButton, true)
        viewModel.isSearchPresented = true
        XCTAssertEqual(viewModel.shouldShowAddButton, false)

        viewModel.member = members[Role.owner.title]
        XCTAssertEqual(viewModel.shouldShowAddButton, false)
        viewModel.isSearchPresented = false
        XCTAssertEqual(viewModel.shouldShowAddButton, true)

        viewModel.member = members[Role.developer.title]
        XCTAssertEqual(viewModel.shouldShowAddButton, true)
        viewModel.isSearchPresented = true
        XCTAssertEqual(viewModel.shouldShowAddButton, false)

        viewModel.member = members[Role.viewer.title]
        viewModel.isSearchPresented = false
        XCTAssertEqual(viewModel.shouldShowAddButton, false)

        viewModel.member = members[Role.marketing.title]
        XCTAssertEqual(viewModel.shouldShowAddButton, false)
    }

    func testKeys() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        XCTAssertEqual(viewModel.keys, nil)

        let expectation = XCTestExpectation(description: "Wait for keys")
        viewModel.$state.sink(receiveValue: { state in
            if case .loaded(let keys) = state, !keys.isEmpty {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(viewModel.keys?.count, viewModel.keysLimit)
    }

    func testOnKeyAppear() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)
        guard let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository else {
            XCTFail("Missing mock")
            return
        }

        let initLimit = viewModel.keysLimit
        var newLimit: Int? = nil
        var newLimitAgain: Int? = nil

        let keysExpectation = XCTestExpectation(description: "Wait for keys")
        let newLimitExpectation = XCTestExpectation(description: "Wait for new keys")
        let newLimitAgainExpectation = XCTestExpectation(description: "Wait for new keys")
        viewModel.$state.sink(receiveValue: { state in
            if case .loaded(let keys) = state, !keys.isEmpty {
                if !keys.isEmpty {
                    keysExpectation.fulfill()
                }
                if let newLimit, keys.count == newLimit {
                    newLimitExpectation.fulfill()
                }
                if let newLimitAgain, keys.count == newLimitAgain {
                    newLimitAgainExpectation.fulfill()
                }
            }
        })
        .store(in: cancelBag)

        wait(for: [keysExpectation], timeout: 5.0)

        // onKeyAppear() PART 1
        viewModel.onKeyAppear(repo.lastKey)
        XCTAssertTrue(viewModel.keysLimit > initLimit)

        newLimit = viewModel.keysLimit
        guard let newLimit else {
            XCTFail("Expectation of number")
            return
        }

        wait(for: [newLimitExpectation], timeout: 5.0)

        XCTAssertEqual(viewModel.keys?.count, newLimit)
        XCTAssertNotEqual(viewModel.keys?.count, nil)

        // onKeyAppear() PARK 2
        viewModel.onKeyAppear(repo.lastKey)
        XCTAssertTrue(viewModel.keysLimit > newLimit)

        newLimitAgain = viewModel.keysLimit

        wait(for: [newLimitAgainExpectation], timeout: 5.0)

        XCTAssertEqual(viewModel.keys?.count, newLimitAgain)
        XCTAssertNotEqual(viewModel.keys?.count, nil)
    }

    func testAnAddButtonTapped() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        XCTAssertEqual(coordinator.project, nil)
        viewModel.onAddButtonTapped()
        XCTAssertEqual(coordinator.project, viewModel.project)
    }

    func testOnSettingsTapped() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        XCTAssertFalse(coordinator.showProjectSettingsCalled)
        viewModel.onSettingsTapped()
        XCTAssertTrue(coordinator.showProjectSettingsCalled)
    }

    func testOnKeyTapped() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        let key: Key = .init(translation: [:], createdAt: .now, lastUpdatedAt: .now, status: [:])
        XCTAssertEqual(coordinator.key, nil)
        XCTAssertEqual(coordinator.project, nil)
        viewModel.onKeyTapped(key)
        XCTAssertEqual(coordinator.key, key)
        XCTAssertEqual(coordinator.project, Self.project)
    }

    func testOnAlgoliaKeyTapped() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)

        let algoliaKey: AlgoliaKey = .init(createdAt: .init(seconds: 0, nanoseconds: 0),
                                           lastUpdatedAt: .init(seconds: 0, nanoseconds: 0),
                                           status: [:], 
                                           translation: [:],
                                           keyId: "123",
                                           projectId: Self.project.id ?? "",
                                           objectID: "1232",
                                           highlightResult: .init(keyId: .init(value: .init(string: ""),
                                                                               matchLevel: .full,
                                                                               matchedWords: []),
                                                                  translation: [:]))
        let key: Key = .init(id: "123", 
                             translation: [:],
                             createdAt: Date(timeIntervalSince1970: 0),
                             lastUpdatedAt: Date(timeIntervalSince1970: 0), status: [:])
        XCTAssertEqual(coordinator.key, nil)
        XCTAssertEqual(coordinator.project, nil)
        viewModel.onAlgoliaKeyTapped(algoliaKey)
        XCTAssertEqual(coordinator.key, key)
        XCTAssertEqual(coordinator.project, Self.project)
    }

    func testSelectedKeysOrder() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)
        guard let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository else {
            XCTFail("Missing mock")
            return
        }

        XCTAssertEqual(viewModel.selectedKeysOrder, repo.keysOrder)
        repo.keysOrder = nil

        let expectation = XCTestExpectation(description: "Wait for keys order")
        viewModel.$state.sink(receiveValue: { state in
            if repo.keysOrder == .recent {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        viewModel.selectedKeysOrder = .recent

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(repo.keysOrder, .recent)
    }

    func testOnSearchTextDidChange() throws {
        let coordinator = MockProjectDetailCoordinator()
        let viewModel: ProjectDetailViewModel = .init(coordinator: coordinator, project: Self.project)
        guard let repo = coordinator.dependencies.searchRepository as? MockSearchRepository else {
            XCTFail("Missing mock")
            return
        }

        let TOO_SHORT_TEXT = "ne"
        let FOUND_TEXT = "Text"
        let NOT_FOUND_TEST = "not found text"
        let ERROR_TEXT = "error text"

        var searchedKeys: [AlgoliaKey]? = nil

        let searchExpectation = XCTestExpectation()
        let notFoundExpectation = XCTestExpectation()
        let errorExpectation = XCTestExpectation()
        let tooShortExpectation = XCTestExpectation()

        let loadingSearchExpectation = XCTestExpectation()
        let loadingNotFoundExpectation = XCTestExpectation()
        let loadingErrorExpectation = XCTestExpectation()

        viewModel.$state.sink(receiveValue: { state in
            if case .searched(let keys) = state {
                searchedKeys = keys
                searchExpectation.fulfill()
            }

            if case .loading = state {
                if viewModel.searchText == FOUND_TEXT {
                    loadingSearchExpectation.fulfill()
                }
                if viewModel.searchText == NOT_FOUND_TEST {
                    loadingNotFoundExpectation.fulfill()
                }
                if viewModel.searchText == ERROR_TEXT {
                    loadingErrorExpectation.fulfill()
                }
                if viewModel.searchText == TOO_SHORT_TEXT {
                    XCTFail("should not happens")
                }
            }

            if case .notFound = state {
                searchedKeys = []
                notFoundExpectation.fulfill()
            }

            if case .failed = state {
                errorExpectation.fulfill()
            }

            if case .loaded = state, viewModel.searchText == TOO_SHORT_TEXT {
                tooShortExpectation.fulfill()
            }
        })
        .store(in: cancelBag)

        repo.mockSearch = .found
        viewModel.searchText = FOUND_TEXT

        wait(for: [searchExpectation, loadingSearchExpectation], timeout: 5.0)

        XCTAssertEqual(searchedKeys?.count, 10)

        // -------------------------

        repo.mockSearch = .notFound
        viewModel.searchText = NOT_FOUND_TEST

        wait(for: [notFoundExpectation, loadingNotFoundExpectation], timeout: 5.0)

        XCTAssertEqual(searchedKeys?.count, 0)
        if case .notFound = viewModel.state {
            XCTAssert(true)
        } else {
            XCTFail("should be not found")
        }

        // -------------------------

        repo.mockSearch = .error
        viewModel.searchText = ERROR_TEXT

        wait(for: [errorExpectation, loadingErrorExpectation], timeout: 5.0)

        if case .failed = viewModel.state {
            XCTAssert(true)
        } else {
            XCTFail("should be error")
        }

        // -------------------------

        repo.mockSearch = nil
        viewModel.searchText = TOO_SHORT_TEXT

        wait(for: [tooShortExpectation], timeout: 5.0)

        XCTAssertEqual(viewModel.keys?.count, viewModel.keysLimit)

        if case .loaded = viewModel.state {
            XCTAssert(true)
        } else {
            XCTFail("should be loaded")
        }
    }
}

fileprivate final class MockProjectDetailCoordinator: ProjectDetailViewModel.ProjectDetailCoordinator {

    var dependencies: Dependencies = MockDependencies.makeDependencies(firestoreRepository: MockFirestoreRepository(),
                                                                       searchRepository: MockSearchRepository())

    var project: Project? = nil
    var key: Key? = nil
    var showProjectSettingsCalled = false

    func presentCreateKey(project: Project) {
        self.project = project
    }
    
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) {
        self.showProjectSettingsCalled = true
    }
    
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        self.key = key
        self.project = project
    }
}

fileprivate final class MockFirestoreRepository: FirestoreRepository {

    let member: Member = .init(role: .admin, name: "LOADED", surname: "", email: "")

    let lastKey: Key = .init(id: "123", translation: [:], createdAt: Date(timeIntervalSince1970: 1000000),
                             lastUpdatedAt: Date(timeIntervalSince1970: 1000000), status: [:])

    var keysOrder: KeysOrder? = nil

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error> {
        return Just(ProjectDetailViewModelTest.project)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error> {
        return Just(member)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error> {
        var keys: [Key] = .init(repeating: .init(translation: [:], createdAt: .now, lastUpdatedAt: .now, status: [:]), count: limit - 1)
        keys.append(lastKey)
        self.keysOrder = keysOrder
        return Just(keys)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getKeyPublisher(projectId: String, keyId: String) -> AnyPublisher<Key?, Error> {
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Error> {
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getUser(email: String) async throws -> User {
        return .init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init())
    }

    func setProfileName(userId: UserID, name: String, surname: String) async throws {}

    func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws {}
}

fileprivate final class MockSearchRepository: SearchRepository {

    var searchText: String? = nil
    var project: Project? = nil

    enum MockSearch {
        case found
        case notFound
        case error
    }

    var mockSearch: MockSearch? = nil

    func searchKeys(in project: Project,
                    with text: String, 
                    completion: @escaping (Result<[AlgoliaKey], Error>) -> Void) {
        let keys: [AlgoliaKey] = .init(repeating: .init(createdAt: .init(seconds: 0, nanoseconds: 0), 
                                                        lastUpdatedAt: .init(seconds: 0, nanoseconds: 0),
                                                        status: [:],
                                                        translation: [:],
                                                        keyId: "",
                                                        projectId: "",
                                                        objectID: "",
                                                        highlightResult: .init(keyId: .init(value: .init(string: ""),
                                                                                            matchLevel: .full,
                                                                                            matchedWords: []),
                                                                               translation: [:])),
                                       count: 10)
        self.searchText = text
        self.project = project

        switch mockSearch {
        case .found:
            completion(.success(keys))
        case .notFound:
            completion(.success([]))
        case .error:
            completion(.failure(AppError.decodingError))
        default:
            fatalError("Need set emptySearch flag")
        }
    }
}
