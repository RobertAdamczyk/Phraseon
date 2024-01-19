//
//  IsUserProjectOwnerService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct IsUserProjectOwnerService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "isUserProjectOwner"
    }

    struct RequestModel: Codable {
        // empty
    }

    struct ResponseModel: CloudResponse {
        typealias Model = Self

        let isOwner: Bool
    }
}
