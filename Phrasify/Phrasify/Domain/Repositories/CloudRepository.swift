//
//  CloudRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 27.12.23.
//

import FirebaseFunctions
import Foundation

final class CloudRepository {

    private let functions = Functions.functions()

    func createProject(name: String, languages: [Language], baseLanguage: Language, technologies: [Technology]) async throws {
        _ = try await functions.httpsCallable("createProject").call(["name": name,
                                                                     "languages": languages.map{ $0.rawValue },
                                                                     "baseLanguage": baseLanguage.rawValue,
                                                                     "technologies": technologies.map{ $0.rawValue }] as [String : Any])
    }

    func createKey(projectId: String, keyId: String, translation: [String: String]) async throws {
        _ = try await functions.httpsCallable("createKey").call(["projectId": projectId,
                                                                 "keyId": keyId,
                                                                 "translation": translation] as [String : Any])
    }

    func addProjectMember(userId: UserID, projectId: String, role: Role) async throws {
        _ = try await functions.httpsCallable("addProjectMember").call(["userId": userId,
                                                                        "projectId": projectId,
                                                                        "role": role.rawValue] as [String : Any])
    }

    func isUserProjectOwner(userId: UserID) async throws -> Bool {
        let result = try await functions.httpsCallable("isUserProjectOwner").call(["userId": userId] as [String : Any])

        if let data = result.data as? [String: Any], // I need to refactor this to make code clear
           let isOwner = data["isOwner"] as? Bool {
            return isOwner
        } else {
            throw AppError.decodingError
        }
    }
}
