//
//  SetBaseLanguageService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import Foundation
import Model

public struct SetBaseLanguageService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setBaseLanguage"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, baseLanguage: Language) {
            self.projectId = projectId
            self.baseLanguage = baseLanguage
        }

        let projectId: String
        let baseLanguage: Language
    }
}

