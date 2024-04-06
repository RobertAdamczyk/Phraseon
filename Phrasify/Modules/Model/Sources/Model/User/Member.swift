//
//  Member.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 05.01.24.
//

import Foundation
import FirebaseFirestoreSwift

public struct Member: Codable, Hashable, IdentifiableUser {

    @DocumentID public var id: String?
    public var role: Role
    public var name: String?
    public var surname: String?
    public var email: String?
    public var photoUrl: String?

    public init(id: String? = nil, role: Role, name: String? = nil, surname: String? = nil, email: String? = nil, photoUrl: String? = nil) {
        self.id = id
        self.role = role
        self.name = name
        self.surname = surname
        self.email = email
        self.photoUrl = photoUrl
    }
}
