//
//  ProjectIntegrationViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.04.24.
//

import Model
import Common
import SwiftUI

final class ProjectIntegrationViewModel: ObservableObject {

    typealias ProjectIntegrationCoordinator = Coordinator

    @Published var swiftPath: String = ""
    @Published var kotlinPath: String = ""

    var technologies: [Technology] {
        project.technologies
    }

    private let coordinator: ProjectIntegrationCoordinator
    private let project: Project
    private let cancelBag = CancelBag()

    init(coordinator: ProjectIntegrationCoordinator, project: Project) {
        self.coordinator = coordinator
        self.project = project
        if let projectId = project.id {
            if let swiftPath = coordinator.dependencies.localizationSyncRepository.getPath(for: .init(technology: .swift,
                                                                                                      projectId: projectId)) {
                self.swiftPath = swiftPath
            }
            if let kotlinPath = coordinator.dependencies.localizationSyncRepository.getPath(for: .init(technology: .kotlin,
                                                                                                       projectId: projectId)) {
                self.kotlinPath = kotlinPath
            }
        }
        setupSubscribers()
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
                case .kotlin: self?.kotlinPath = url.absoluteString
                }
            }
        }
    }

    func setupSubscribers() {
        guard let projectId = project.id else { return }
        $swiftPath
            .sink { [weak self] path in
                self?.coordinator.dependencies.localizationSyncRepository.setPath(path, for: .init(technology: .swift, 
                                                                                                   projectId: projectId))
            }
            .store(in: cancelBag)

        $kotlinPath
            .sink { [weak self] path in
                self?.coordinator.dependencies.localizationSyncRepository.setPath(path, for: .init(technology: .kotlin,
                                                                                                   projectId: projectId))
            }
            .store(in: cancelBag)
    }
}
