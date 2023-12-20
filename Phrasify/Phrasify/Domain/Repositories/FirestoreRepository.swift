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
    private var listeners: [ListenerRegistration] = []

    // MARK: Collections

    private enum Collections: String {
        case users
        case projects
    }

    // MARK: Babies

    func getProjects(userId: String) async throws -> [Project] {
        let snapshot = try await db.collection(Collections.users.rawValue).document(userId)
                                   .collection(Collections.projects.rawValue).getDocuments()
        let projects: [Project] = try snapshot.documents.map { document in
            return try document.data(as: Project.self)
        }
        return projects
    }

    func createProject(userId: String, name: String, languages: [Language], technologies: [Technology]) async throws -> String {
        let ref =  db.collection(Collections.users.rawValue).document(userId)
                     .collection(Collections.projects.rawValue).document()
        let project: Project = .init(name: name, technologies: technologies, languages: languages)
        try await ref.setData(from: project)
        return ref.documentID
    }

    func getProjectsPublisher(userId: String) -> AnyPublisher<[Project], Never> {
        return db.collection(Collections.users.rawValue).document(userId)
                 .collection(Collections.projects.rawValue)
                 .snapshotPublisher()
                 .map { snapshot in
                     snapshot.documents.compactMap { document -> Project? in
                         try? document.data(as: Project.self)
                     }
                 }
                 .catch { _ in Just<[Project]>([])}
                 .eraseToAnyPublisher()
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
