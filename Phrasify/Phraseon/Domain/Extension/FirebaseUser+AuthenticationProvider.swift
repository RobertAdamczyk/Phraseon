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
            if let authenticationProvider = AuthenticationProvider(rawValue: userInfo.providerID) {
                return authenticationProvider
            }
        }
        return nil
    }
}
