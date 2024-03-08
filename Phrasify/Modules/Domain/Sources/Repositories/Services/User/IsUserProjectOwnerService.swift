//
//  IsUserProjectOwnerService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

public struct IsUserProjectOwnerService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "isUserProjectOwner"
    }

    struct RequestModel: Codable {
        // empty
    }

    public struct ResponseModel: CloudResponse {

        typealias Model = Self

        public init(isOwner: Bool) {
            self.isOwner = isOwner
        }

        public let isOwner: Bool
    }
}
