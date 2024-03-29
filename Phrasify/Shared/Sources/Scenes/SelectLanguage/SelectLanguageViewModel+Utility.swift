//
//  SelectLanguageViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.03.24.
//

import Model

extension SelectLanguageViewModel {

    struct Utility {

        let selectedLanguages: [Language]
        let context: Context

        var availableLanguages: [Language] {
            Language.allCases.filter { !selectedLanguages.contains($0) }
        }

        var shouldShowPlaceholder: Bool {
            selectedLanguages.isEmpty
        }

        var shouldPrimaryButtonDisabled: Bool {
            selectedLanguages.isEmpty
        }

        var subtitle: String {
            switch context {
            case .settings:
                "Adjust your language settings – your choices can be modified at any time to better suit your project's needs."
            case .createProject:
                "Choose supported languages – remember, you can change it at any time."
            }
        }

        var buttonText: String {
            switch context {
            case .settings: "Save"
            case .createProject: "Continue"
            }
        }
    }
}
