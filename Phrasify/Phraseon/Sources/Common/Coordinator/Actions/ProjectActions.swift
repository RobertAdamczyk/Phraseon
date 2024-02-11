//
//  ProjectActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.01.24.
//

import Foundation

protocol ProjectActions {

    func presentCreateKey(project: Project)
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase)
    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func presentInviteMember(project: Project)
    func showChangeProjectOwner(project: Project)
    func showLeaveProjectWarning(project: Project)
    func showLeaveProjectInformation()
    func showDeleteProjectWarning(project: Project)
    func showDeleteMemberWarning(project: Project, member: Member)
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func showProjectIntegration(project: Project)
    func showDeleteKeyWarning(project: Project, key: Key)
}
