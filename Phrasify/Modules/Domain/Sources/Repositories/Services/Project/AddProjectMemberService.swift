//
//  AddProjectMemberService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct AddProjectMemberService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "addProjectMember"
    }

    public struct RequestModel: Codable {

        public init(userId: UserID, projectId: String, role: Role) {
            self.userId = userId
            self.projectId = projectId
            self.role = role
        }

        let userId: UserID
        let projectId: String
        let role: Role
    }
}
