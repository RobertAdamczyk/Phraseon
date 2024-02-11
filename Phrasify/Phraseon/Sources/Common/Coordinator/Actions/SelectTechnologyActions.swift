//
//  SelectTechnologyActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 04.01.24.
//

import Foundation

protocol SelectTechnologyActions {

    func showSelectTechnology(name: String, languages: [Language], baseLanguage: Language)
    func showSelectedTechnologies(project: Project)
}
