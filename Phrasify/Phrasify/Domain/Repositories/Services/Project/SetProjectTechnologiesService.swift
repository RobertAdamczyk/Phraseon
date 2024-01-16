//
//  SetProjectTechnologiesService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

struct SetProjectTechnologiesService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setProjectTechnologies"
    }

    struct RequestModel: Codable {
        let projectId: String
        let technologies: [Technology]
    }
}
