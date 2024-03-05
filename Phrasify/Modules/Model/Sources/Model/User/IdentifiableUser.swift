//
//  IdentifiableUser.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 09.01.24.
//

import Foundation

public protocol IdentifiableUser {

    var id: String? { get }
    var email: String? { get }
    var name: String? { get }
    var surname: String? { get }
    var photoUrl: String? { get }
}
