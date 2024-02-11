//
//  SelectLanguageActions.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 04.01.24.
//

import Foundation

protocol SelectLanguageActions {

    func showSelectLanguage(name: String)
    func showSelectedLanguages(project: Project)

    func showSelectBaseLanguage(name: String, languages: [Language])
    func showSelectedBaseLanguage(project: Project)
}
