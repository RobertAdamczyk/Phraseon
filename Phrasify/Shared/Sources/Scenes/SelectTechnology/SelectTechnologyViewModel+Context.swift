//
//  SelectTechnologyViewModel+Context.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 28.03.24.
//

import Model

extension SelectTechnologyViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(projectName: String, languages: [Language], baseLanguage: Language)
    }
}
