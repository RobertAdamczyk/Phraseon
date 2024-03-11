//
//  ProfileNameViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import XCTest
import Combine
@testable import Phraseon_InHouse
@testable import Model
@testable import Common
@testable import Domain
@testable import FirebaseStorage

final class ProfileNameViewModelTest: XCTestCase {

    private var profileName: String { "name" }
    private var profileSurname: String { "surname" }

    private let coordinator = ProfileNameCoordinator()

    private var repo: MockFirestoreRepository? {
        coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
    }

    lazy var viewModel: ProfileNameViewModel = {
        return ProfileNameViewModel(name: profileName, surname: profileSurname, coordinator: coordinator)
    }()

    func testInit() throws {
        XCTAssertEqual(profileName, viewModel.name)
        XCTAssertEqual(profileSurname, viewModel.surname)
    }

    func testOnPrimaryButtonTapped() throws {
        Task {
            XCTAssertNil(coordinator.calledPopView)
            await viewModel.onPrimaryButtonTapped()
            XCTAssertEqual(repo?.calledName, profileName)
            XCTAssertEqual(repo?.calledSurname, profileSurname)
            XCTAssertEqual(repo?.calledUserId, coordinator.dependencies.authenticationRepository.userId)
            XCTAssertTrue(coordinator.calledPopView == true)
        }
    }
}

fileprivate final class ProfileNameCoordinator: ProfileNameViewModel.ProfileNameCoordinator {

    var calledPopView: Bool?

    var dependencies: Dependencies = MockDependencies.makeDependencies(firestoreRepository: MockFirestoreRepository())

    func popToRoot() {
        // empty
    }
    
    func popView() {
        self.calledPopView = true
    }
    

}
