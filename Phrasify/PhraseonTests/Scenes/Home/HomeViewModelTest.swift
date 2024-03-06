//
//  HomeViewModelTest.swift
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

final class HomeViewModelTest: XCTestCase {

    let cancelBag = CancelBag()

    func testInit() throws {
        let coordinator = HomeCoordinator()
        let viewModel: HomeViewModel = .init(coordinator: coordinator)

        XCTAssertEqual(viewModel.projects, [])

        let expectation = XCTestExpectation(description: "Wait for 1 second")
        viewModel.$projects.sink(receiveValue: { projects in
            if !projects.isEmpty {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.projects.count, 3)
    }

    func testOnProfileTapped() throws {
        let coordinator = HomeCoordinator()
        let viewModel: HomeViewModel = .init(coordinator: coordinator)

        XCTAssertFalse(coordinator.profileCalled)
        viewModel.onProfileTapped()
        XCTAssertTrue(coordinator.profileCalled)
    }

    func testOnProjectTapped() throws {
        let coordinator = HomeCoordinator()
        let viewModel: HomeViewModel = .init(coordinator: coordinator)

        let project: Project = .init(name: "NAME", technologies: [], languages: [], baseLanguage: .english,
                                     members: [], owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: "")

        XCTAssertEqual(coordinator.project, nil)
        viewModel.onProjectTapped(project: project)
        XCTAssertEqual(coordinator.project, project)
    }

    func testOnAddProjectTapped() throws {
        let coordinator = HomeCoordinator()
        let viewModel: HomeViewModel = .init(coordinator: coordinator)

        XCTAssertFalse(coordinator.createProjectCalled)
        viewModel.onAddProjectTapped()
        XCTAssertTrue(coordinator.createProjectCalled)
    }
}

fileprivate final class HomeCoordinator: HomeViewModel.HomeCoordinator {

    var profileCalled: Bool = false
    var createProjectCalled: Bool = false
    var project: Project? = nil

    var dependencies: Dependencies = MockDependencies.makeDependencies(firestoreRepository: MockFirestoreRepository())

    func showProfile() {
        profileCalled = true
    }
    
    func showProjectDetails(project: Project) {
        self.project = project
    }
    
    func presentCreateProject() {
        createProjectCalled = true
    }
}

fileprivate final class MockFirestoreRepository: FirestoreRepository {

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error> {
        let projects: [Project] = [
            .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
                  owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: ""),
            .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
                  owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: ""),
            .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
                  owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: "")
        ]

        return Just(projects)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error> {
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error> {
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error> {
        return Just([])
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
