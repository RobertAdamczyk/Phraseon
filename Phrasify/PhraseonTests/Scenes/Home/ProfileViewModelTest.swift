//
//  ProfileViewModelTests.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 08.03.24.
//

import XCTest
import Combine
import Common
import Model

final class ProfileViewModelTests: XCTestCase {

    let cancelBag = CancelBag()

    private var testUser: User? = .init(id: "123", email: "email", name: "name", surname: "surname", createdAt: .now, subscriptionId: .init())

    func testInit() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        repo?.userPublisher = testUser

        let expectation = XCTestExpectation(description: "Wait for user")
        viewModel.$user.sink(receiveValue: { user in
            if user.currentValue != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 3.0)

        XCTAssert(true)
    }

    func testOnNameTapped() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)

        let repo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        repo?.userPublisher = testUser

        let expectation = XCTestExpectation(description: "Wait for user")
        viewModel.$user.sink(receiveValue: { user in
            if user.currentValue != nil {
                expectation.fulfill()
            }
        })
        .store(in: cancelBag)

        wait(for: [expectation], timeout: 3.0)

        viewModel.onNameTapped()

        XCTAssertEqual(viewModel.user.currentValue?.name, coordinator.calledName)
        XCTAssertEqual(viewModel.user.currentValue?.surname, coordinator.calledSurname)
    }

    func testOnPasswordTapped() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)
        let repo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository

        repo?.mockAuthenticationProvider = .apple
        viewModel.onPasswordTapped()
        XCTAssertEqual(coordinator.calledAuthenticationProvider, .apple)

        repo?.mockAuthenticationProvider = .google
        viewModel.onPasswordTapped()
        XCTAssertEqual(coordinator.calledAuthenticationProvider, .google)

        repo?.mockAuthenticationProvider = .password
        viewModel.onPasswordTapped()
        XCTAssertEqual(coordinator.calledAuthenticationProvider, .password)
    }

    func testOnMembershipTapped() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)

        XCTAssertNil(coordinator.calledPresentPaywall)
        viewModel.onMembershipTapped()
        XCTAssertTrue(coordinator.calledPresentPaywall == true)
    }

    func testOnLogoutDeleteUserTapped() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)
        let repo = coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository

        XCTAssertNil(repo?.calledLogout)
        XCTAssertNil(repo?.calledDeleteUser)
        XCTAssertNil(coordinator.calledShowDeleteUser)
        Task {
            await viewModel.onLogoutTapped()
            XCTAssertTrue(repo?.calledLogout == true)
            XCTAssertNil(repo?.calledDeleteUser)
            viewModel.onDeleteAccountTapped()
            XCTAssertTrue(coordinator.calledShowDeleteUser == true)
        }
    }

    func testUploadProfileImage() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)
        let userId = coordinator.dependencies.authenticationRepository.userId
        let storageRepo = coordinator.dependencies.storageRepository as? MockStorageRepository
        let firestoreRepo = coordinator.dependencies.firestoreRepository as? MockFirestoreRepository
        guard let uiImage: UIImage = .init(systemName: "xmark") else {
            XCTFail()
            return
        }

        XCTAssertNil(storageRepo?.calledUploadImageCalled)
        XCTAssertNil(storageRepo?.mockDownloadURL)
        XCTAssertNil(firestoreRepo?.calledUserId)
        XCTAssertNil(firestoreRepo?.calledPhotoUrl)

        let url: URL? = .init(string: "https://www.google.com")
        storageRepo?.mockDownloadURL = url

        Task {
            try await viewModel.uploadProfileImage(uiImage)
            XCTAssertTrue(storageRepo?.calledUploadImageCalled == true)
            XCTAssertEqual(firestoreRepo?.calledPhotoUrl, url?.absoluteString)
            XCTAssertEqual(firestoreRepo?.calledUserId, userId)
        }
    }

    func testPublicProperties() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)

        viewModel.user = .idle

        XCTAssertEqual(viewModel.utility.shouldShowLoading, false)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.utility.shouldShowContent, false)
        XCTAssertEqual(viewModel.utility.shouldShowError, false)
        XCTAssertEqual(viewModel.utility.userName, "-")

        viewModel.user = .isLoading

        XCTAssertEqual(viewModel.utility.shouldShowLoading, true)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.utility.shouldShowContent, true)
        XCTAssertEqual(viewModel.utility.shouldShowError, false)
        XCTAssertEqual(viewModel.utility.userName, "-")

        viewModel.user = .failed(AppError.imageNil)

        XCTAssertEqual(viewModel.utility.shouldShowLoading, false)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.utility.shouldShowContent, false)
        XCTAssertEqual(viewModel.utility.shouldShowError, true)
        XCTAssertEqual(viewModel.utility.userName, "-")

        viewModel.user = .failed(AppError.decodingError)
        (coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository)?.mockCreationDate = .now

        XCTAssertEqual(viewModel.utility.shouldShowLoading, true)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.utility.shouldShowContent, true)
        XCTAssertEqual(viewModel.utility.shouldShowError, false)
        XCTAssertEqual(viewModel.utility.userName, "-")

        viewModel.user = .failed(AppError.decodingError)
        (coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository)?.mockCreationDate = .now.addingTimeInterval(31)

        XCTAssertEqual(viewModel.utility.shouldShowLoading, false)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.utility.shouldShowContent, false)
        XCTAssertEqual(viewModel.utility.shouldShowError, true)
        XCTAssertEqual(viewModel.utility.userName, "-")

        viewModel.user = .loaded(.init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init()))

        XCTAssertEqual(viewModel.utility.shouldShowLoading, false)
        XCTAssertEqual(viewModel.utility.shouldInteractionDisabled, false)
        XCTAssertEqual(viewModel.utility.shouldShowContent, true)
        XCTAssertEqual(viewModel.utility.shouldShowError, false)
        XCTAssertEqual(viewModel.utility.userName, "Enter your name")

        viewModel.user = .loaded(.init(email: "", name: "Rob", surname: "", createdAt: .now, subscriptionId: .init()))
        XCTAssertEqual(viewModel.utility.userName, "Rob")

        viewModel.user = .loaded(.init(email: "", name: "Rob", surname: "xxx", createdAt: .now, subscriptionId: .init()))
        XCTAssertEqual(viewModel.utility.userName, "Rob xxx")
    }
}

fileprivate final class ProfileCoordinator: ProfileViewModel.ProfileCoordinator {

    var calledName: String?
    var calledSurname: String?
    var calledAuthenticationProvider: AuthenticationProvider?
    var calledPresentPaywall: Bool?
    var calledShowDeleteUser: Bool?

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository(),
                                                                       firestoreRepository: MockFirestoreRepository(),
                                                                       storageRepository: MockStorageRepository())

    func popToRoot() {

    }
    
    func popView() {

    }
    
    func presentPaywall() {
        self.calledPresentPaywall = true
    }
    
    func showProfileName(name: String?, surname: String?) {
        self.calledName = name
        self.calledSurname = surname
    }
    
    func showChangePassword(authenticationProvider: Model.AuthenticationProvider) {
        self.calledAuthenticationProvider = authenticationProvider
    }
    
    func showProfileDeleteWarning() {
        self.calledShowDeleteUser = true
    }
    
    func showProfile() {

    }
    
    func showProjectDetails(project: Model.Project) {

    }
    
    func presentCreateProject() {

    }
}
