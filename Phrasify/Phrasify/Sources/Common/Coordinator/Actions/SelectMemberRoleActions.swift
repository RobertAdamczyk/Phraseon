//
//  SelectMemberRoleActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import Foundation

protocol SelectMemberRoleActions {

    func showSelectMemberRole(email: String, project: Project, user: User)
    func showSelectMemberRole(member: Member, project: Project)
}
