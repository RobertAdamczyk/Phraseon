//
//  SelectLanguageActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 04.01.24.
//

import Foundation

protocol SelectLanguageActions {

    func showSelectLanguage(name: String)
    func showSelectedLanguages(languages: [Language])
}
