//
//  ProjectsActions.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 25.03.24.
//

import Foundation
import Model

protocol ProjectsActions {

    func showProjectDetail(project: Project)
    func presentCreateProject()
}
