//
//  SetProjectLanguagesService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct SetProjectLanguagesService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setProjectLanguages"
    }

    struct RequestModel: Codable {
        let projectId: String
        let languages: [Language]
    }
}