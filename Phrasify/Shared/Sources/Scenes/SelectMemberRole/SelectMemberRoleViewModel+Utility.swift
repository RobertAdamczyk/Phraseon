//
//  SelectMemberRoleViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.04.24.
//

import Model

extension SelectMemberRoleViewModel {

    struct Utility {

        private let context: Context
        private let selectedRole: Role?

        init(context: Context, selectedRole: Role?) {
            self.context = context
            self.selectedRole = selectedRole
        }

        var user: IdentifiableUser? {
            switch context {
            case .members(let member): return member
            case .invite(let user): return user
            }
        }

        var shouldButtonDisabled: Bool {
            selectedRole == nil
        }

        var buttonText: String {
            switch context {
            case .members: "Confirm change"
            case .invite: "Invite member"
            }
        }
    }
}
