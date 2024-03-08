//
//  SetProjectTechnologiesService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

public struct SetProjectTechnologiesService: CloudService {

    typealias Model = RequestModel

    let requestModel: RequestModel

    var functionName: String {
        "setProjectTechnologies"
    }

    public struct RequestModel: Codable {

        public init(projectId: String, technologies: [Technology]) {
            self.projectId = projectId
            self.technologies = technologies
        }

        let projectId: String
        let technologies: [Technology]
    }
}
