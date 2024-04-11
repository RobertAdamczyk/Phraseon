//
//  ProjectDetailActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 25.02.24.
//

import Foundation
import Model
import Domain

protocol ProjectDetailActions {

    func presentCreateKey(project: Project)
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase)
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase)
}
