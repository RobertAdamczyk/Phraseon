//
//  PreviewFirestoreRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import Combine
import Model
import Domain

final class PreviewFirestoreRepository: FirestoreRepository {

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
        Just(nil)
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
        // empty
    }
}
