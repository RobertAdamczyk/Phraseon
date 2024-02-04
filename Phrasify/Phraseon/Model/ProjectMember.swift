//
//  ProjectMember.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import Foundation
import FirebaseFirestoreSwift

struct ProjectMember: Codable, Hashable {

    @DocumentID var id: String?
    var userId: UserID
    var role: Role
}
