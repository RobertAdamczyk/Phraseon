//
//  ProfileActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 01.01.24.
//

import Foundation

protocol ProfileActions {
    
    func showProfileName(name: String, surname: String)
    func showChangePassword(authenticationProvider: AuthenticationProvider)
    func showProfileDeleteWarning()
    func dismissSheet()
}
