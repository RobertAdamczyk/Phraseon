//
//  ProjectActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 01.01.24.
//

import Foundation

protocol ProjectActions {

    func presentCreateKey(project: Project)
    func showProjectSettings(project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase)
    func presentInviteMember(project: Project)
    func showChangeProjectOwner(project: Project)
    func showLeaveProjectWarning(project: Project)
    func showDeleteProjectWarning(project: Project)
}
