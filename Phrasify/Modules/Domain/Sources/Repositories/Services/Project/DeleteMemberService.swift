//
//  DeleteMemberService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct DeleteMemberService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteMember"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, userId: UserID) {
            self.projectId = projectId
            self.userId = userId
        }

        let projectId: String
        let userId: UserID
    }
}
