//
//  EnterContentKeyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

final class EnterContentKeyViewModel: ObservableObject {

    enum Context {
        case create(keyId: String)
        case edit(key: Key, language: Language)
    }

    typealias EnterContentKeyCoordinator = Coordinator & FullScreenCoverActions & NavigationActions

    @Published var translation: String = ""

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

    private let project: Project
    private let coordinator: EnterContentKeyCoordinator
    private let context: Context

    init(coordinator: EnterContentKeyCoordinator, project: Project, context: Context) {
        self.coordinator = coordinator
        self.context = context
        self.project = project
        if case .edit(let key, _) = context, let translation = key.translation[language.rawValue] {
            self.translation = translation
        }
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let projectId = project.id else { return }
        do {
            switch context {
            case .create(let keyId):
                try await coordinator.dependencies.cloudRepository.createKey(.init(projectId: projectId, 
                                                                                   keyId: keyId,
                                                                                   language: language,
                                                                                   translation: translation))
                coordinator.dismissFullScreenCover()
                ToastView.showSuccess(message: "Phrase successfully created.")
            case .edit(let key, _):
                guard let keyId = key.id else { return }
                try await coordinator.dependencies.cloudRepository.changeContentKey(.init(projectId: projectId, 
                                                                                          keyId: keyId,
                                                                                          language: language,
                                                                                          translation: translation))
                coordinator.popView()
                ToastView.showSuccess(message: "Phrase content updated successfully.")
            }
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}
