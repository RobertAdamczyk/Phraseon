//
//  CreateProjectService.swift
//  Phrasify
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

    func getParameters() throws -> [String: Any] {
        let jsonData = try JSONEncoder().encode(requestModel)
        if let parameters = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] {
            return parameters
        }
        throw AppError.encodingError
    }

    struct RequestModel: Codable {
        let name: String
        let languages: [Language]
        let baseLanguage: Language
        let technologies: [Technology]
    }
}
