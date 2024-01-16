//
//  ChangeProjectOwnerService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct ChangeProjectOwnerService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "changeOwner"
    }

    struct RequestModel: Codable {
        let projectId: String
        let newOwnerEmail: String
    }
}
