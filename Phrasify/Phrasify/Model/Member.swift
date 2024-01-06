//
//  Member.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 05.01.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Member: Codable, Hashable {

    @DocumentID var id: String?
    var role: Role
    var name: String
    var surname: String
}
