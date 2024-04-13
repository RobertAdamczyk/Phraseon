//
//  CreateKeyViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 10.04.24.
//

import SwiftUI
import Model
import Domain

final class CreateKeyViewModel: ObservableObject {

    typealias CreateKeyCoordinator = Coordinator & SheetActions

    enum Context {
        case create
        case edit(key: Key, language: Language)
    }

    @Published var keyId: String = ""
    @Published var translation: String = ""

    var utility: Utility {
        .init(keyId: keyId)
    }

    var subtitle: String {
        switch context {
        case .create:
            "Enter the content of the phrase - remember, that the base language is \(language.localizedTitle)."
        case .edit:
            "Change the content of the phrase - remember, that language is \(language.localizedTitle)."
        }

    }

    var buttonText: String {
        switch context {
        case .create: "Create phrase"
        case .edit: "Confirm change"
        }
    }

    var language: Language {
        switch context {
        case .create: project.baseLanguage
        case .edit(_, let language): language
        }
    }

    var isBaseLanguage: Bool {
        switch context {
        case .create: return true
        case .edit(_, let language): return language == project.baseLanguage
        }
    }

    let project: Project

    private let coordinator: CreateKeyCoordinator
    private let context: Context

    init(coordinator: CreateKeyCoordinator, project: Project, context: Context) {
        self.coordinator = coordinator
        self.project = project
        self.context = context
        if case .edit(let key, _) = context, let translation = key.translation[language.rawValue], let id = key.id {
            self.translation = translation
            self.keyId = id
        }
    }

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
    }

    @MainActor
    func onContinueButtonTapped() async {
        guard let projectId = project.id else { return }
        do {
            switch context {
            case .create:
                try await coordinator.dependencies.cloudRepository.createKey(.init(projectId: projectId,
                                                                                   keyId: keyId,
                                                                                   language: language,
                                                                                   translation: translation))
                coordinator.dismissSheet()
                ToastView.showSuccess(message: "Phrase successfully created.")
            case .edit(let key, _):
                guard let keyId = key.id else { return }
                try await coordinator.dependencies.cloudRepository.changeContentKey(.init(projectId: projectId,
                                                                                          keyId: keyId,
                                                                                          language: language,
                                                                                          translation: translation))
                coordinator.dismissSheet()
                ToastView.showSuccess(message: "Phrase content updated successfully.")
            }
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}
