//
//  DeleteKeyService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct DeleteKeyService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteKey"
    }

    struct RequestModel: Codable {
        let projectId: String
        let keyId: String
    }
}
