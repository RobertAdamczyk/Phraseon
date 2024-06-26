//
//  FirestoreRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine
import Model

public protocol FirestoreRepository {

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error>

    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error>

    func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error>

    func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error>

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error>

    func getAllKeys(projectId: String) async throws -> [Key]

    func getKeyPublisher(projectId: String, keyId: String) -> AnyPublisher<Key?, Error>

    func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Error>

    func getUser(email: String) async throws -> User

    func setProfileName(userId: UserID, name: String, surname: String) async throws

    func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws
}

public final class FirestoreRepositoryImpl: FirestoreRepository {

    public init() { }

    private let db = Firestore.firestore()

    // MARK: Collections

    private enum Collections: String {
        case users
        case projects
        case keys
        case members
    }

    // MARK: Projects

    public func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Error> {
        return db.collection(Collections.projects.rawValue).whereField(Project.CodingKeys.members.rawValue, arrayContains: userId)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Project? in
                         try? document.data(as: Project.self)
                     }
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    public func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Error> {
        return db.collection(Collections.projects.rawValue).document(projectId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: Project.self)
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    // MARK: Members

    public func getMembersPublisher(projectId: String) -> AnyPublisher<[Member], Error> {
        return db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.members.rawValue)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Member? in
                         try? document.data(as: Member.self)
                     }
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    public func getMemberPublisher(userId: UserID, projectId: String) -> AnyPublisher<Member?, Error> {
        return db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.members.rawValue).document(userId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: Member.self)
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    // MARK: Keys

    public func getKeysPublisher(projectId: String, keysOrder: KeysOrder, limit: Int) -> AnyPublisher<[Key], Error> {
        return db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.keys.rawValue)
                 .order(by: keysOrder.value.field, descending: keysOrder.value.descending)
                 .limit(to: limit)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Key? in
                         try? document.data(as: Key.self)
                     }
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    public func getAllKeys(projectId: String) async throws -> [Key] {
        let ref = db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.keys.rawValue)
        let querySnapshot = try await ref.getDocuments()
        let keys = try querySnapshot.documents.compactMap { (document) -> Key? in
            try document.data(as: Key.self)
        }
        return keys
    }

    public func getKeyPublisher(projectId: String, keyId: String) -> AnyPublisher<Key?, Error> {
        return db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.keys.rawValue).document(keyId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: Key.self)
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    // MARK: User

    public func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Error> {
        return db.collection(Collections.users.rawValue).document(userId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: User.self)
                 }
                 .mapError { error -> Error in
                     return error
                 }
                 .eraseToAnyPublisher()
    }

    public func getUser(email: String) async throws -> User {
        let ref = db.collection(Collections.users.rawValue).whereField(User.CodingKeys.email.rawValue, isEqualTo: email)
        let querySnapshot = try await ref.getDocuments()
        if let document = querySnapshot.documents.first {
            return try document.data(as: User.self)
        }
        throw AppError.notFound
    }

    public func setProfileName(userId: UserID, name: String, surname: String) async throws {
        let ref =  db.collection(Collections.users.rawValue).document(userId)
        try await ref.setData(["name": name, "surname": surname], merge: true)
    }

    public func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws {
        let ref =  db.collection(Collections.users.rawValue).document(userId)
        try await ref.updateData(["photoUrl": photoUrl])
    }
}

extension DocumentReference {

    fileprivate func setData<T: Encodable>(from value: T,
                               mergeFields: [Any],
                               encoder: Firestore.Encoder = Firestore.Encoder()) async throws {
      let encoded = try encoder.encode(value)
      try await setData(encoded, mergeFields: mergeFields)
    }

    fileprivate func setData<T: Encodable>(from value: T,
                               merge: Bool = true,
                               encoder: Firestore.Encoder = Firestore.Encoder()) async throws {
      let encoded = try encoder.encode(value)
      try await setData(encoded, merge: merge)
    }
}
