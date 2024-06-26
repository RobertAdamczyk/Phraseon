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

    var utility: Utility {
        .init(selectedLanguages: selectedLanguages, context: context)
    }

    var isInNavigationStack: Bool {
        if case .settings = context {
            return true
        } else {
            return false
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
