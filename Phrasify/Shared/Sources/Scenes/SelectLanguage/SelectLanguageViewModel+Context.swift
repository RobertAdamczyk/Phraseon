//
//  SelectLanguageViewModel+Context.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.03.24.
//

import Model

extension SelectLanguageViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(name: String)
    }
}
