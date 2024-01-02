//
//  CreateProjectActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation

protocol CreateProjectActions {

    func dismiss()
    func showSelectLanguage(name: String)
    func showSelectTechnology(name: String, languages: [Language])
}
