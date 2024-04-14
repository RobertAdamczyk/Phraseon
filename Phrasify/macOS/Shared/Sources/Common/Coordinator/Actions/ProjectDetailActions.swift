//
//  CreateKeyActions.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 11.04.24.
//

import Foundation
import Model
import Domain

protocol ProjectDetailActions {

    func showCreateKey(project: Project, context: CreateKeyViewModel.Context)
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func showDeleteKeyWarning(project: Project, key: Key)
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase)
}
