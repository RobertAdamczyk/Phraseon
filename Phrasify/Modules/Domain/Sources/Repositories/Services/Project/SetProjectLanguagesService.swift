//
//  SetProjectLanguagesService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct SetProjectLanguagesService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setProjectLanguages"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, languages: [Language]) {
            self.projectId = projectId
            self.languages = languages
        }

        let projectId: String
        let languages: [Language]
    }
}
