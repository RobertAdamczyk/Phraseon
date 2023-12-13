//
//  StartActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation

protocol StartActions {

    func showLogin()
    func showRegister()
    func showForgetPassword()
    func showSetPassword()
    func closeForgetPassword()
    func popToRoot()
}
