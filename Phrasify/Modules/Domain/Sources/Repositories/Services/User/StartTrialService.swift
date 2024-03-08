//
//  StartTrialService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.02.24.
//

import Foundation

public struct StartTrialService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "startTrial"
    }

    public struct RequestModel: Codable {

        public init() { }
    }
}
