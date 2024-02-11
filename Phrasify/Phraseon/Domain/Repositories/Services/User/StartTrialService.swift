//
//  StartTrialService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.02.24.
//

import Foundation

struct StartTrialService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "startTrial"
    }

    struct RequestModel: Codable {
    }
}
