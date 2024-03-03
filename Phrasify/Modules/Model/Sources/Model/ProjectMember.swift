//
//  ProjectMember.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.12.23.
//

import Foundation
import FirebaseFirestoreSwift

public struct ProjectMember: Codable, Hashable {

    @DocumentID public var id: String?
    public var userId: UserID
    public var role: Role
}
