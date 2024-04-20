//
//  ProjectSettingsViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.04.24.
//

import Domain

extension ProjectSettingsViewModel {

    struct Utility {

        private let coordinator: ProjectSettingsViewModel.ProjectSettingsCoordinator

        init(coordinator: ProjectSettingsViewModel.ProjectSettingsCoordinator) {
            self.coordinator = coordinator
        }

        var ownerName: String {
            guard let user = coordinator.dependencies.userDomain.user.currentValue else { return "" }
            let name = user.name ?? ""
            let surname = user.surname ?? ""

            let fullNameParts = [name, surname].filter { !$0.isEmpty }
            let fullName = fullNameParts.joined(separator: " ")

            return fullName
        }
    }
}
