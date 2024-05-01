//
//  LocalizationSyncManager.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 01.05.24.
//

import Foundation
import SwiftUI
import Domain
import Model

final class LocalizationSyncManager {

    @AppStorage("selectedTechnology") var selectedTechnology: Technology = .swift
    @AppStorage("swiftPath") private var swiftPath: String = ""

    private var keys: [Key] = []
    private let coordinator: ProjectDetailViewModel.ProjectDetailCoordinator
    private let projectUseCase: ProjectUseCase

    init(projectUseCase: ProjectUseCase, coordinator: ProjectDetailViewModel.ProjectDetailCoordinator) {
        self.coordinator = coordinator
        self.projectUseCase = projectUseCase
    }

    @MainActor
    func synchronizeKeys() async {
        guard let projectId = projectUseCase.project.id else { return }
        do {
            keys = try await coordinator.dependencies.firestoreRepository.getAllKeys(projectId: projectId)
            openPanel()
        } catch {
            print(error)
            ToastView.showGeneralError()
        }
    }

    @MainActor
    private func openPanel() {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Sync phrases"
        openPanel.message = "Select a folder to save the localization files."
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = URL(string: swiftPath)

        openPanel.begin { [weak self] response in
            if response == .OK {
                guard let folderURL = openPanel.url else { return }
                self?.saveLocalizationFiles(at: folderURL)
            }
        }
    }

    private func saveLocalizationFiles(at folderURL: URL) {
        switch selectedTechnology {
        case .swift: saveLocalizationSwiftFiles(at: folderURL)
        }
    }

    private func saveLocalizationSwiftFiles(at folderURL: URL) {
        let languages = projectUseCase.project.languages
        for lang in languages {
            let localeFolderName = {
                switch lang {
                case .english: return "en.lproj"
                case .portugueseEuropean: return "pt-PT.lproj"
                case .portugueseBrazilian: return "pt-BR.lproj"
                default: return "\(lang.rawValue.lowercased()).lproj"
                }
            }()
            let localeFolderURL = folderURL.appendingPathComponent(localeFolderName, isDirectory: true)

            do {
                try FileManager.default.createDirectory(at: localeFolderURL, withIntermediateDirectories: true, attributes: nil)
                let fileURL = localeFolderURL.appendingPathComponent("Localizable.strings")

                // Create the content of the Localizable.strings file for the current language
                let content = keys.reduce("") { partialResult, key in
                    if let translation = key.translation[lang.rawValue], let keyId = key.id {
                        return partialResult + "\"\(keyId)\" = \"\(translation)\";\n"
                    }
                    return partialResult
                }

                try content.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                ToastView.showGeneralError()
            }
        }
    }
}
