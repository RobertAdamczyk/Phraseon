//
//  SelectLanguageViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectLanguageViewModel: ObservableObject {

    typealias SelectLanguageCoordinator = Coordinator & NewProjectActions

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

    init(coordinator: SelectLanguageCoordinator) {
        self.coordinator = coordinator
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

    }
}
