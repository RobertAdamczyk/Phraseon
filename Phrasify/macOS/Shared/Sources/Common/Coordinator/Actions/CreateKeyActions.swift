//
//  CreateKeyActions.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 11.04.24.
//

import Foundation
import Model

protocol CreateKeyActions {

    func showCreateKey(project: Project, context: CreateKeyViewModel.Context)
}
