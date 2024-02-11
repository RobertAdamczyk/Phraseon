//
//  RootActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.12.23.
//

import Foundation

protocol RootActions {

    func showProfile()
    
    func showProjectDetails(project: Project)

    func presentCreateProject()
}