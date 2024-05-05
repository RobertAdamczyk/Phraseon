//
//  File.swift
//  
//
//  Created by Robert Adamczyk on 05.05.24.
//

import Foundation

public struct TechnologyProjectAssociation: Codable, Hashable {
    public let technology: Technology
    public let projectId: ProjectID

    public init(technology: Technology, projectId: ProjectID) {
        self.technology = technology
        self.projectId = projectId
    }
}
