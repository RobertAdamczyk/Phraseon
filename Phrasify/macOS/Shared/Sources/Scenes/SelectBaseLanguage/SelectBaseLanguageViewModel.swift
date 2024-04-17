//
//  SelectBaseLanguageViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI
import Model
import Domain

final class SelectBaseLanguageViewModel: ObservableObject {

    typealias SelectBaseLanguageCoordinator = Coordinator & SelectTechnologyActions & NavigationActions & SheetActions

    @Published var selectedBaseLanguage: Language?

    var utility: Utility {
        .init(context: context, selectedBaseLanguage: selectedBaseLanguage)
    }

    var isInNavigationStack: Bool {
        if case .settings = context {
            return true
        } else {
            return false
        }
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

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
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
