//
//  SelectTechnologyViewModel+Shared.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 28.03.24.
//

import Model

extension SelectTechnologyViewModel {

    struct Utility {

        let selectedTechnologies: [Technology]
        let context: Context

        var availableTechnologies: [Technology] {
            Technology.allCases.filter { !selectedTechnologies.contains($0) }
        }

        var shouldShowPlaceholder: Bool {
            selectedTechnologies.isEmpty
        }

        var shouldPrimaryButtonDisabled: Bool {
            selectedTechnologies.isEmpty
        }

        var subtitle: String {
            switch context {
            case .settings:
                "Modify your project's technology settings – feel free to adjust them at any time to align with your evolving project requirements."
            case .createProject:
                "Choose the technology in which the project is created – remember, you can change it at any time."
            }
        }

        var buttonText: String {
            switch context {
            case .settings: "Save"
            case .createProject: "Create Project"
            }
        }
    }
}
