//
//  ApproveTranslationService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 18.01.24.
//

import Foundation

struct ApproveTranslationService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "approveTranslation"
    }

    struct RequestModel: Codable {
        let projectId: String
        let keyId: String
        let language: Language
    }
}
