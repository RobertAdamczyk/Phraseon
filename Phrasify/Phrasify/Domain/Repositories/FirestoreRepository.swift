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

    // MARK: Projects

    func createProject(userId: UserID, name: String, languages: [Language], technologies: [Technology]) async throws -> String {
        let ref =  db.collection(Collections.projects.rawValue).document()
        let project: Project = .init(name: name, technologies: technologies, languages: languages, 
                                     members: [userId], owner: userId)
        try await ref.setData(from: project)
        return ref.documentID
    }

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
