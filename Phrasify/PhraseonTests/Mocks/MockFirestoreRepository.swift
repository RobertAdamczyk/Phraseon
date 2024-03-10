//
//  MockFirestoreRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 11.03.24.
//

import Combine
@testable import Phraseon_InHouse
@testable import Model
@testable import Domain

final class MockFirestoreRepository: FirestoreRepository {

    @Published var memberPublisher: Member?
    @Published var keysPublisher: [Key] = []
    @Published var projectsPublisher: [Project] = []
    @Published var projectPublisher: Project?
    @Published var userPublisher: User?

    var calledKeysOrder: KeysOrder?
    var calledPhotoUrl: String?
    var calledUserId: String?
    var calledLimit: Int?

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error> {
        $projectsPublisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error> {
        $projectPublisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error> {
        $memberPublisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error> {
        self.calledLimit = limit
        self.calledKeysOrder = keysOrder
        return $keysPublisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getKeyPublisher(projectId: String, keyId: String) -> AnyPublisher<Key?, Error> {
        return Just(nil)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Error> {
        $userPublisher
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getUser(email: String) async throws -> User {
        return .init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init())
    }

    func setProfileName(userId: UserID, name: String, surname: String) async throws {}

    func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws {
        self.calledUserId = userId
        self.calledPhotoUrl = photoUrl
    }
}
