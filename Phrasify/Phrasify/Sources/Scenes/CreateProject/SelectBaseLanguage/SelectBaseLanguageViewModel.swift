//
//  SelectBaseLanguageViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

final class SelectBaseLanguageViewModel: ObservableObject {

    typealias SelectBaseLanguageCoordinator = Coordinator & SelectTechnologyActions

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
        switch context {
        case .settings(let project):
            do {
                print("XD")
            } catch {
                ToastView.showError(message: error.localizedDescription)
            }
        case .createProject(let name, let languages):
            guard let selectedBaseLanguage else { return }
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
