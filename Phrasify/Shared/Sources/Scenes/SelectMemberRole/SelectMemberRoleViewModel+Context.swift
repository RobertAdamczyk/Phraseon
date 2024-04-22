//
//  SelectMemberRoleViewModel+Context.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.04.24.
//

import Model

extension SelectMemberRoleViewModel {

    enum Context {
        case members(member: Member)
        case invite(user: User)
    }
}
