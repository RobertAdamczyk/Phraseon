//
//  SelectBaseLanguageViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI
import Model

final class SelectBaseLanguageViewModel: ObservableObject {

    typealias SelectBaseLanguageCoordinator = Coordinator & SelectTechnologyActions & NavigationActions

    @Published var selectedBaseLanguage: Language?

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

    private let coordinator: SelectBaseLanguageCoordinator
    private let context: Context

    init(coordinator: SelectBaseLanguageCoordinator, context: Context) {
        self.coordinator = coordinator
        self.context = context
        if case .settings(let project) = context {
            self.selectedBaseLanguage = project.baseLanguage
        }
    }

    func onLanguageTapped(_ language: Language) {
        selectedBaseLanguage = language
    }

    @MainActor
    func onSaveButtonTapped() async {
        guard let selectedBaseLanguage else { return }
        switch context {
        case .settings(let project):
            guard let projectId = project.id else { return }
            do {
                try await coordinator.dependencies.cloudRepository.setBaseLanguage(.init(projectId: projectId,
                                                                                         baseLanguage: selectedBaseLanguage))
                coordinator.popView()
                ToastView.showSuccess(message: "Base language successfully set to \(selectedBaseLanguage.localizedTitle).")
            } catch {
                let errorHandler = ErrorHandler(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
            }
        case .createProject(let name, let languages):
            coordinator.showSelectTechnology(name: name, languages: languages, baseLanguage: selectedBaseLanguage)
        }

    }
}

extension SelectBaseLanguageViewModel {

    enum Context {
        case settings(project: Project)
        case createProject(name: String, languages: [Language])
    }
}
