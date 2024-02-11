//
//  FirebaseUser+AuthenticationProvider.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 01.01.24.
//

import Foundation
import Firebase

extension Firebase.User {

    var authenticationProvider: AuthenticationProvider? {
        for userInfo in self.providerData {
            return .init(rawValue: userInfo.providerID)
        }
        return nil
    }
}
