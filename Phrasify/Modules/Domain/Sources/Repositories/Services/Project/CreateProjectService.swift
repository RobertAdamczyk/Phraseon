//
//  CreateProjectService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct CreateProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "createProject"
    }

    public struct RequestModel: Codable {

        public init(name: String, languages: [Language], baseLanguage: Language, technologies: [Technology]) {
            self.name = name
            self.languages = languages
            self.baseLanguage = baseLanguage
            self.technologies = technologies
        }

        let name: String
        let languages: [Language]
        let baseLanguage: Language
        let technologies: [Technology]
    }
}
