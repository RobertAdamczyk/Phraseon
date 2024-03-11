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
@testable import Common
@testable import Domain

final class ProjectDetailViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

    private let searchKeys: [AlgoliaKey] = .init(repeating: .init(createdAt: .init(seconds: 0, nanoseconds: 0),
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

    private var lastTestKey: Key {
        .init(id: "123", translation: [:], createdAt: Date(timeIntervalSince1970: 1000000), lastUpdatedAt: Date(timeIntervalSince1970: 1000000), status: [:])
    }

    private func getTestKeys(limit: Int) -> [Key] {
        var keys: [Key] = .init(repeating: .init(translation: [:], createdAt: .now, lastUpdatedAt: .now, status: [:]), count: limit - 1)
        keys.append(lastTestKey)
        return keys
    }

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

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        repo?.memberPublisher = .init(role: .admin, name: "LOADED", surname: "", email: "")

        let expectation = XCTestExpectation(description: "Wait for member")
        viewModel.$member.sink(receiveValue: { member in
            if member != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.member, repo?.memberPublisher)
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

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        repo?.keysPublisher = getTestKeys(limit: viewModel.keysLimit)

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

        repo.keysPublisher = getTestKeys(limit: viewModel.keysLimit)

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
        guard let lastKey = repo.keysPublisher.last else {
            XCTFail()
            return
        }
        viewModel.onKeyAppear(lastKey)
        XCTAssertTrue(viewModel.keysLimit > initLimit)
        guard let calledLimit = repo.calledLimit else {
            XCTFail()
            return
        }
        XCTAssertTrue(calledLimit > initLimit)

        newLimit = viewModel.keysLimit
        guard let newLimit else {
            XCTFail("Expectation of number")
            return
        }

        repo.keysPublisher = getTestKeys(limit: newLimit)
        wait(for: [newLimitExpectation], timeout: 5.0)

        XCTAssertEqual(viewModel.keys?.count, newLimit)
        XCTAssertNotEqual(viewModel.keys?.count, nil)

        // onKeyAppear() PART 2
        guard let lastKey = repo.keysPublisher.last else {
            XCTFail()
            return
        }
        viewModel.onKeyAppear(lastKey)
        XCTAssertTrue(viewModel.keysLimit > newLimit)

        newLimitAgain = viewModel.keysLimit
        guard let newLimitAgain else {
            XCTFail("Expectation of number")
            return
        }
        repo.keysPublisher = getTestKeys(limit: newLimitAgain)
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

        XCTAssertEqual(viewModel.selectedKeysOrder, repo.calledKeysOrder)
        repo.calledKeysOrder = nil

        let expectation = XCTestExpectation(description: "Wait for keys order")
        viewModel.$state.sink(receiveValue: { state in
            if repo.calledKeysOrder == .recent {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        viewModel.selectedKeysOrder = .recent

        wait(for: [expectation], timeout: 5.0)

        XCTAssertEqual(repo.calledKeysOrder, .recent)
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

        repo.mockSearch = .found(searchKeys)
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
        (coordinator.dependencies.firestoreRepository as? MockFirestoreRepository)?.keysPublisher = getTestKeys(limit: viewModel.keysLimit)
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
