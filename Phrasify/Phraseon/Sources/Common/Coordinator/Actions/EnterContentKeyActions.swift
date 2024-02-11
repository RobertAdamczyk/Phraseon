//
//  EnterContentKeyActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 10.01.24.
//

import Foundation

protocol EnterContentKeyActions {

    func showEnterContentKey(keyId: String, project: Project)
    func showEditContentKey(language: Language, key: Key, project: Project)
}
