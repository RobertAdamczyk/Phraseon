//
//  DeleteMemberService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct DeleteMemberService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "deleteMember"
    }

    struct RequestModel: Codable {
        let projectId: String
        let userId: UserID
    }
}
