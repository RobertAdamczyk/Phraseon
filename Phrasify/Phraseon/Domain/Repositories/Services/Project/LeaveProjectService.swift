//
//  LeaveProjectService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct LeaveProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "leaveProject"
    }

    struct RequestModel: Codable {
        let projectId: String
    }
}
