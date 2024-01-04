//
//  SelectTechnologyActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 04.01.24.
//

import Foundation

protocol SelectTechnologyActions {

    func showSelectTechnology(name: String, languages: [Language])
    func showSelectedTechnologies(project: Project)
}
