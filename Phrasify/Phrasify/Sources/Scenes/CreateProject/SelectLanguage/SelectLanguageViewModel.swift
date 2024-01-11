//
//  SelectLanguageViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectLanguageViewModel: ObservableObject {

    typealias SelectLanguageCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions &  NavigationActions

    @Published var selectedLanguages: [Language] = []

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

    private let coordinator: SelectLanguageCoordinator
    private let context: Context

    init(coordinator: SelectLanguageCoordinator, context: Context) {
        self.coordinator = coordinator
        self.context = context
        if case .settings(let project) = context {
            selectedLanguages = project.languages
        }
    }

    func onLanguageTapped(_ language: Language) {
        withAnimation(.snappy) {
            selectedLanguages.insert(language, at: 0)
        }
    }

    func onLanguageDeleteTapped(_ language: Language) {
        withAnimation(.snappy) {
            selectedLanguages.removeAll { $0 == language }
        }
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        switch context {
        case .settings(let project):
            guard let projectId = project.id else { return }
            do {
                try await coordinator.dependencies.cloudRepository.setProjectLanguages(projectId: projectId, languages: selectedLanguages)
                coordinator.popView()
            } catch {
                ToastView.showError(message: error.localizedDescription)
            }
        case .createProject(let name):
            coordinator.showSelectTechnology(name: name, languages: selectedLanguages)
        }
    }
}

extension SelectLanguageViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(name: String)
    }
}
