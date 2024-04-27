//
//  ProjectIntegrationViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.04.24.
//

import Model
import SwiftUI

final class ProjectIntegrationViewModel: ObservableObject {

    typealias ProjectIntegrationCoordinator = Coordinator

    @AppStorage("swiftPath") var swiftPath: String = ""

    var technologies: [Technology] {
        project.technologies
    }

    private let coordinator: ProjectIntegrationCoordinator
    private let project: Project

    init(coordinator: ProjectIntegrationCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
    }

    func onSelectPathTapped(_ technology: Technology) {
        let folderPicker = NSOpenPanel()

        folderPicker.canChooseDirectories = true
        folderPicker.canChooseFiles = false
        folderPicker.allowsMultipleSelection = false
        folderPicker.canDownloadUbiquitousContents = true
        folderPicker.canResolveUbiquitousConflicts = true
        folderPicker.allowedContentTypes = [.folder]

        folderPicker.begin { [weak self] response in

            if let url = folderPicker.urls.first, response == .OK {
                switch technology {
                case .swift: self?.swiftPath = url.absoluteString
                }
            }
        }
    }
}
