//
//  CreateKeyActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import Foundation

protocol CreateKeyActions {

    func dismiss()
    func showEnterContentKey(keyId: String, project: Project)
}
