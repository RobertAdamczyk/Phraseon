//
//  ChangeContentKeyService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct ChangeContentKeyService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "changeContentKey"
    }

    struct RequestModel: Codable {
        let projectId: String
        let keyId: String
        let translation: Translation
    }
}