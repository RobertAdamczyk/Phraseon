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

    func createKey(projectId: String, keyId: String, translation: [String: String]) async throws {
        _ = try await functions.httpsCallable("createKey").call(["projectId": projectId,
                                                                 "keyId": keyId,
                                                                 "translation": translation] as [String : Any])
    }
}
