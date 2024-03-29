//
//  SelectLanguageViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI
import Model
import Domain

final class SelectLanguageViewModel: ObservableObject {

    typealias SelectLanguageCoordinator = Coordinator & SelectLanguageActions & SelectTechnologyActions &  NavigationActions

    @Published var selectedLanguages: [Language] = []

    var utility: Utility {
        .init(selectedLanguages: selectedLanguages, context: context)
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
