//
//  ChangeMemberRoleService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct ChangeMemberRoleService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "changeMemberRole"
    }

    struct RequestModel: Codable {
        let userId: UserID
        let projectId: String
        let role: Role
    }
}