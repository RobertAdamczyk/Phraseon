//
//  LeaveProjectService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

public struct LeaveProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "leaveProject"
    }

    public struct RequestModel: Codable {

        public init(projectId: String) {
            self.projectId = projectId
        }

        let projectId: String
    }
}
