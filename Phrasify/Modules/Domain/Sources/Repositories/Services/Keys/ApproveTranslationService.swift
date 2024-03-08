//
//  ApproveTranslationService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 18.01.24.
//

import Foundation
import Model

public struct ApproveTranslationService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "approveTranslation"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, keyId: String, language: Language) {
            self.projectId = projectId
            self.keyId = keyId
            self.language = language
        }

        let projectId: String
        let keyId: String
        let language: Language
    }
}
