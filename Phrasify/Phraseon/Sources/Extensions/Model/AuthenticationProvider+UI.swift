//
//  AuthenticationProvider+UI.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 05.03.24.
//

import Foundation

extension AuthenticationProvider {

    var providerTitle: String {
        return switch self {
        case .password: "Firebase"
        case .google: "Google"
        case .apple: "Apple"
        }
    }
}
