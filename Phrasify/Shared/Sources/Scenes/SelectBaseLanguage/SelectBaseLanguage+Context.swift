//
//  SelectBaseLanguage+Context.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 28.03.24.
//

import Model

extension SelectBaseLanguageViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(name: String, languages: [Language])
    }
}

