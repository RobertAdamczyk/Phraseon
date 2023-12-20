//
//  NewProjectActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation

protocol NewProjectActions {

    func dismiss()
    func popToRoot()
    func showSelectLanguage(name: String)
    func showSelectTechnology(name: String, languages: [Language])
}
