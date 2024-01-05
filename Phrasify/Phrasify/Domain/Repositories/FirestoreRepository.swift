//
//  FirestoreRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreCombineSwift
import Combine

final class FirestoreRepository {

    private let db = Firestore.firestore()

    // MARK: Collections

    private enum Collections: String {
        case users
        case projects
        case keys
        case members
    }

    // MARK: Projects

    func getProjectsPublisher(userId: UserID) -> AnyPublisher<[Project], Never> {
        return db.collection(Collections.projects.rawValue).whereField(Project.CodingKeys.members.rawValue, arrayContains: userId)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Project? in
                         try? document.data(as: Project.self)
                     }
                 }
                 .catch { _ in Just<[Project]>([])}
                 .eraseToAnyPublisher()
    }

    func getProjectPublisher(projectId: String) -> AnyPublisher<Project?, Never> {
        return db.collection(Collections.projects.rawValue).document(projectId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: Project.self)
                 }
                 .catch { _ in Just<Project?>(nil)}
                 .eraseToAnyPublisher()
    }

    func setProjectLanguages(projectId: String, languages: [Language]) async throws {
        let ref =  db.collection(Collections.projects.rawValue).document(projectId)
        try await ref.updateData(["languages": languages.map{$0.rawValue}])
    }

    func setProjectTechnologies(projectId: String, technologies: [Technology]) async throws {
        let ref =  db.collection(Collections.projects.rawValue).document(projectId)
        try await ref.updateData(["technologies": technologies.map{$0.rawValue}] as [String: Any])
    }

    // MARK: Keys

    func getKeysPublisher(projectId: String, keysOrder: KeysOrder) -> AnyPublisher<[Key], Never> {
        return db.collection(Collections.projects.rawValue).document(projectId).collection(Collections.keys.rawValue)
                 .order(by: keysOrder.value.field, descending: keysOrder.value.descending)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Key? in
                         try? document.data(as: Key.self)
                     }
                 }
                 .catch { _ in Just<[Key]>([])}
                 .eraseToAnyPublisher()
    }

    // MARK: User

    func getUserPublisher(userId: UserID) -> AnyPublisher<User?, Never> {
        return db.collection(Collections.users.rawValue).document(userId)
                 .snapshotPublisher()
                 .map { snapshot in
                     try? snapshot.data(as: User.self)
                 }
                 .catch { _ in Just<User?>(nil)}
                 .eraseToAnyPublisher()
    }

    func setProfileName(userId: UserID, name: String, surname: String) async throws {
        let ref =  db.collection(Collections.users.rawValue).document(userId)
        try await ref.updateData(["name": name,
                                  "surname": surname])
    }

    func setProfilePhotoUrl(userId: UserID, photoUrl: String) async throws {
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
