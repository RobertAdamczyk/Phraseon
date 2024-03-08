//
//  ChangeProjectOwnerService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

public struct ChangeProjectOwnerService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "changeOwner"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, newOwnerEmail: String) {
            self.projectId = projectId
            self.newOwnerEmail = newOwnerEmail
        }

        let projectId: String
        let newOwnerEmail: String
    }
}
