//
//  AddProjectMemberService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

struct AddProjectMemberService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "addProjectMember"
    }

    struct RequestModel: Codable {
        let userId: UserID 
        let projectId: String
        let role: Role
    }
}
