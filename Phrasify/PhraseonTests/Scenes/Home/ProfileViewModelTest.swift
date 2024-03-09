//
//  ProfileViewModelTests.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 08.03.24.
//

import XCTest
import Combine
@testable import Phraseon_InHouse
@testable import Model
@testable import Common
@testable import Domain
@testable import FirebaseStorage

final class ProfileViewModelTests: XCTestCase {

    let cancelBag = CancelBag()

    func testInit() throws {
        let coordinator = ProfileCoordinator()
        let viewModel = ProfileViewModel(coordinator: coordinator)

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

        XCTAssertEqual(viewModel.shouldShowLoading, false)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.shouldShowContent, false)
        XCTAssertEqual(viewModel.shouldShowError, false)
        XCTAssertEqual(viewModel.userName, "-")

        viewModel.user = .isLoading

        XCTAssertEqual(viewModel.shouldShowLoading, true)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.shouldShowContent, true)
        XCTAssertEqual(viewModel.shouldShowError, false)
        XCTAssertEqual(viewModel.userName, "-")

        viewModel.user = .failed(AppError.imageNil)

        XCTAssertEqual(viewModel.shouldShowLoading, false)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.shouldShowContent, false)
        XCTAssertEqual(viewModel.shouldShowError, true)
        XCTAssertEqual(viewModel.userName, "-")

        viewModel.user = .failed(AppError.decodingError)
        (coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository)?.mockCreationDate = .now

        XCTAssertEqual(viewModel.shouldShowLoading, true)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.shouldShowContent, true)
        XCTAssertEqual(viewModel.shouldShowError, false)
        XCTAssertEqual(viewModel.userName, "-")

        viewModel.user = .failed(AppError.decodingError)
        (coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository)?.mockCreationDate = .now.addingTimeInterval(31)

        XCTAssertEqual(viewModel.shouldShowLoading, false)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, true)
        XCTAssertEqual(viewModel.shouldShowContent, false)
        XCTAssertEqual(viewModel.shouldShowError, true)
        XCTAssertEqual(viewModel.userName, "-")

        viewModel.user = .loaded(.init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init()))

        XCTAssertEqual(viewModel.shouldShowLoading, false)
        XCTAssertEqual(viewModel.shouldInteractionDisabled, false)
        XCTAssertEqual(viewModel.shouldShowContent, true)
        XCTAssertEqual(viewModel.shouldShowError, false)
        XCTAssertEqual(viewModel.userName, "Enter your name")

        viewModel.user = .loaded(.init(email: "", name: "Rob", surname: "", createdAt: .now, subscriptionId: .init()))
        XCTAssertEqual(viewModel.userName, "Rob")

        viewModel.user = .loaded(.init(email: "", name: "Rob", surname: "xxx", createdAt: .now, subscriptionId: .init()))
        XCTAssertEqual(viewModel.userName, "Rob xxx")
    }
}

fileprivate final class MockStorageRepository: StorageRepository {

    var calledUploadImageCalled: Bool?
    var mockDownloadURL: URL?

    func uploadImage(path: StorageRepositoryImpl.StoragePath, imageData: Data) async throws -> StorageMetadata {
        self.calledUploadImageCalled = true
        return .init()
    }
    
    func downloadURL(for path: StorageRepositoryImpl.StoragePath) async throws -> URL {
        return mockDownloadURL ?? .applicationDirectory
    }
}

fileprivate final class ProfileCoordinator: ProfileViewModel.ProfileCoordinator {

    var calledName: String?
    var calledSurname: String?
    var calledAuthenticationProvider: AuthenticationProvider?
    var calledPresentPaywall: Bool?
    var calledShowDeleteUser: Bool?

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository(),
                                                                       firestoreRepository: MockFirestoreRepository())

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

fileprivate final class MockFirestoreRepository: FirestoreRepository {

    var calledPhotoUrl: String?
    var calledUserId: String?

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error> {
        Just([Project]())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error> {
        Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error> {
        Just([Member]())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error> {
        Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error> {
        Just([Key]())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getKeyPublisher(projectId: String, keyId: String) -> AnyPublisher<Key?, Error> {
        Just(nil)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Error> {
        Just(.init(id: "123", email: "email", name: "name", surname: "surname", createdAt: .now, subscriptionId: .init()))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
    }

    func getUser(email: String) async throws -> User {
        return .init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init())
    }

    func setProfileName(userId: UserID, name: String, surname: String) async throws {
        // empty
    }

    func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws {
        self.calledUserId = userId
        self.calledPhotoUrl = photoUrl
    }
}
