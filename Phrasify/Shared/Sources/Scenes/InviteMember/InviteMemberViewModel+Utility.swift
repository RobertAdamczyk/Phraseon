//
//  InviteMemberViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 22.04.24.
//

import Domain
import Model

extension InviteMemberViewModel {

    struct Utility {

        private let project: Project
        private let email: String

        init(project: Project, email: String) {
            self.project = project
            self.email = email
        }

        var shouldPrimaryButtonDisabled: Bool {
            email.isEmpty
        }

        func checkIsUserAlreadyProjectMember(userId: UserID?) throws {
            guard let userId else { throw AppError.notFound }
            if project.members.contains(where: { $0 == userId }) {
                throw AppError.alreadyMember
            }
        }
    }
}
