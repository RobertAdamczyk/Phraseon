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
import Common

final class LocalizationSyncManager: ObservableObject {

    @Published var selectedTechnology: Technology?
    @Published var project: Project

    var shouldSyncButtonDisabled: Bool {
        selectedTechnology == nil
    }

    var technologies: [Technology] {
        project.technologies
    }

    private var projectId: String? {
        projectUseCase.project.id
    }

    private var keys: [Key] = []
    private let coordinator: ProjectDetailViewModel.ProjectDetailCoordinator
    private let projectUseCase: ProjectUseCase
    private let cancelBag = CancelBag()

    private var localizationSyncRepository: LocalizationSyncRepository {
        coordinator.dependencies.localizationSyncRepository
    }

    init(projectUseCase: ProjectUseCase, coordinator: ProjectDetailViewModel.ProjectDetailCoordinator) {
        self.coordinator = coordinator
        self.projectUseCase = projectUseCase
        self.project = projectUseCase.project
        projectUseCase.$project.assign(to: &$project)
        setupSelectedTechnologySubscriber()
        setupProjectSubscriber()
    }

    @MainActor
    func synchronizeKeys() async {
        guard let projectId else { return }
        do {
            keys = try await coordinator.dependencies.firestoreRepository.getAllKeys(projectId: projectId)
            openPanel()
        } catch {
            print(error)
            ToastView.showGeneralError()
        }
    }

    private func setupSelectedTechnologySubscriber() {
        guard let projectId = project.id else { return }
        $selectedTechnology
            .sink { [weak self] technology in
                guard let technology else { return }
                self?.coordinator.dependencies.localizationSyncRepository.setSelectedTechnology(technology, for: projectId)
            }
            .store(in: cancelBag)
    }

    private func setupProjectSubscriber() {
        $project
            .sink { [weak self] project in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if let projectId, let selectedTechnology = localizationSyncRepository.getSelectedTechnology(for: projectId),
                       technologies.contains(selectedTechnology) {
                        self.selectedTechnology = selectedTechnology
                    } else {
                        self.selectedTechnology = nil
                    }
                }
            }
            .store(in: cancelBag)
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
        if let projectId, let selectedTechnology,
           let technologyPathString = localizationSyncRepository.getPath(for: .init(technology: selectedTechnology,
                                                                                    projectId: projectId)){
            openPanel.directoryURL = URL(string: technologyPathString)
        }

        openPanel.begin { [weak self] response in
            if response == .OK {
                guard let folderURL = openPanel.url else { return }
                self?.saveUrlIfNeeded(folderURL)
                self?.saveLocalizationFiles(at: folderURL)
            }
        }
    }

    private func saveUrlIfNeeded(_ url: URL) {
        guard let projectId, let selectedTechnology else { return }
        if localizationSyncRepository.getPath(for: .init(technology: selectedTechnology, projectId: projectId)) == nil {
            localizationSyncRepository.setPath(url.absoluteString, for: .init(technology: selectedTechnology, projectId: projectId))
        }
    }

    private func saveLocalizationFiles(at folderURL: URL) {
        guard let selectedTechnology else { return }
        switch selectedTechnology {
        case .swift: saveLocalizationSwiftFiles(at: folderURL)
        case .kotlin: saveLocalizationKotlinFiles(at: folderURL)
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

    private func saveLocalizationKotlinFiles(at folderURL: URL) {
        let languages = projectUseCase.project.languages
        let baseLanguage = projectUseCase.project.baseLanguage
        for lang in languages {
            let localeFolderName = {
                if lang == baseLanguage {
                    return "values"
                }
                switch lang {
                case .english: return "values-en"
                case .portugueseEuropean: return "values-pt"
                case .portugueseBrazilian: return "values-rBR"
                case .mandarinChineseSimplified: return "values-zh-rCN"
                default: return "values-\(lang.rawValue.lowercased())"
                }
            }()
            let localeFolderURL = folderURL.appendingPathComponent(localeFolderName, isDirectory: true)

            do {
                try FileManager.default.createDirectory(at: localeFolderURL, withIntermediateDirectories: true, attributes: nil)
                let fileURL = localeFolderURL.appendingPathComponent("strings.xml")

                // Create the content of the strings.xml file for the current language
                let content = keys.reduce("<resources>\n") { partialResult, key in
                    if let translation = key.translation[lang.rawValue], let keyId = key.id {
                        return partialResult + "    <string name=\"\(keyId)\">\(translation)</string>\n"
                    }
                    return partialResult
                } + "</resources>\n"

                try content.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                ToastView.showGeneralError()
            }
        }
    }
}
