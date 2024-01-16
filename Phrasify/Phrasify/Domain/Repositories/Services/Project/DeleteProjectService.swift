//
//  DeleteProjectService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct DeleteProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteProject"
    }

    struct RequestModel: Codable {
        let projectId: String
    }
}
