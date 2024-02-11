//
//  CreateProjectService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct CreateProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "createProject"
    }

    struct RequestModel: Codable {
        let name: String
        let languages: [Language]
        let baseLanguage: Language
        let technologies: [Technology]
    }
}
