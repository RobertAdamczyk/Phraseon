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

    private var testProjects: [Project] = [
        .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
              owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: ""),
        .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
              owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: ""),
        .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [],
              owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: "")
    ]

    func testInit() throws {
        let coordinator = HomeCoordinator()
        let viewModel: HomeViewModel = .init(coordinator: coordinator)

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        repo?.projectsPublisher = testProjects

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
