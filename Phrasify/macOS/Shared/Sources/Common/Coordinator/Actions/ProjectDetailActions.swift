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
    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func showLeaveProjectWarning(project: Project)
    func showLeaveProjectInformation()
    func showDeleteProjectWarning(project: Project)
    func showChangeProjectOwner(project: Project)
    func showDeleteMemberWarning(project: Project, member: Member)
    func presentInviteMember(project: Project)
    func showProjectIntegration(project: Project)
}
