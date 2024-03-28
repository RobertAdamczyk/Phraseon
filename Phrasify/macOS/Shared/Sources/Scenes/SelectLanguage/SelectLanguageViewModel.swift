//
//  SelectLanguageViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI
import Model
import Domain

final class SelectLanguageViewModel: ObservableObject {

    typealias SelectLanguageCoordinator = Coordinator & SelectLanguageActions &  NavigationActions & SheetActions

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

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
    }

    func onLanguageTapped(_ language: Language) {
        guard !selectedLanguages.contains(language) else { return }
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
                try await coordinator.dependencies.cloudRepository.setProjectLanguages(.init(projectId: projectId,
                                                                                             languages: selectedLanguages))
                coordinator.popView()
                ToastView.showSuccess(message: "Project languages successfully updated.")
            } catch {
                let errorHandler = ErrorHandler(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
            }
        case .createProject(let name):
            coordinator.showSelectBaseLanguage(name: name, languages: selectedLanguages)
        }
    }
}

extension SelectLanguageViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(name: String)
    }
}

