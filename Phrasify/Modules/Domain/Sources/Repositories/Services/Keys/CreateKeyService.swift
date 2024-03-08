//
//  CreateKeyService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct CreateKeyService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "createKey"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, keyId: String, language: Language, translation: String) {
            self.projectId = projectId
            self.keyId = keyId
            self.language = language
            self.translation = translation
        }

        let projectId: String
        let keyId: String
        let language: Language
        let translation: String
    }
}
