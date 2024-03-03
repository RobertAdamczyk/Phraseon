//
//  SetBaseLanguageService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import Foundation
import Model

struct SetBaseLanguageService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setBaseLanguage"
    }

    struct RequestModel: Codable {
        let projectId: String
        let baseLanguage: Language
    }
}

