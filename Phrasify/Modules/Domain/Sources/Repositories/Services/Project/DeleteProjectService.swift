//
//  DeleteProjectService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

public struct DeleteProjectService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteProject"
    }

    public struct RequestModel: Codable {

        public init(projectId: String) {
            self.projectId = projectId
        }

        let projectId: String
    }
}
