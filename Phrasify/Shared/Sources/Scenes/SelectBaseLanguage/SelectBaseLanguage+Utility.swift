//
//  SelectBaseLanguage+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 28.03.24.
//

import Model

extension SelectBaseLanguageViewModel {

    struct Utility {

        let context: Context
        let selectedBaseLanguage: Language?

        var languages: [Language] {
            switch context {
            case .settings(let project): return project.languages
            case .createProject(_, let languages): return languages
            }
        }

        var buttonText: String {
            switch context {
            case .settings: "Save"
            case .createProject: "Continue"
            }
        }

        var shouldButtonDisabled: Bool {
            selectedBaseLanguage == nil
        }
    }
}
