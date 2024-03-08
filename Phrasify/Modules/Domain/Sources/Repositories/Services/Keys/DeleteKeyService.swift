//
//  DeleteKeyService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

public struct DeleteKeyService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteKey"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, keyId: String) {
            self.projectId = projectId
            self.keyId = keyId
        }

        let projectId: String
        let keyId: String
    }
}
