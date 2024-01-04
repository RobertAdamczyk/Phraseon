//
//  SelectLanguageViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectLanguageViewModel: ObservableObject {

    typealias SelectLanguageCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions

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

    private let coordinator: SelectLanguageCoordinator
    private let context: Context

    init(coordinator: SelectLanguageCoordinator, context: Context) {
        self.coordinator = coordinator
        self.context = context
        if case .settings(let languages) = context {
            selectedLanguages = languages
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

    func onPrimaryButtonTapped() {
        switch context {
        case .settings(let languages):
            print("// TODO: Save languages")
        case .createProject(let name):
            coordinator.showSelectTechnology(name: name, languages: selectedLanguages)
        }
    }
}

extension SelectLanguageViewModel {

    enum Context {
        case settings(languages: [Language])
        case createProject(name: String)
    }
}
