//
//  SelectTechnologyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & FullScreenCoverActions

    @Published var selectedTechnologies: [Technology] = []

    var availableTechnologies: [Technology] {
        Technology.allCases.filter { !selectedTechnologies.contains($0) }
    }

    var shouldShowPlaceholder: Bool {
        selectedTechnologies.isEmpty
    }

    var shouldPrimaryButtonDisabled: Bool {
        selectedTechnologies.isEmpty
    }

    var subtitle: String {
        switch context {
        case .settings:
            "Modify your project's technology settings – feel free to adjust them at any time to align with your evolving project requirements."
        case .createProject:
            "Choose the technology in which the project is created – remember, you can change it at any time."
        }
    }

    var buttonText: String {
        switch context {
        case .settings: "Save"
        case .createProject: "Create Project"
        }
    }

    private let coordinator: SelectTechnologyCoordinator
    private let context: Context

    init(coordinator: SelectTechnologyCoordinator, context: Context) {
        self.coordinator = coordinator
        self.context = context
        if case .settings(let technologies) = context {
            selectedTechnologies = technologies
        }
    }

    func onTechnologyTapped(_ technology: Technology) {
        withAnimation(.snappy) {
            selectedTechnologies.insert(technology, at: 0)
        }
    }

    func onTechnologyDeleteTapped(_ technology: Technology) {
        withAnimation(.snappy) {
            selectedTechnologies.removeAll { $0 == technology }
        }
    }

    @MainActor
    func onPrimaryButtonTapped() async {
        guard let userId = coordinator.dependencies.authenticationRepository.currentUser?.uid else { return }
        do {
            switch context {
            case .settings(let technologies):
                print("TODO: Save technologies")
            case .createProject(let projectName, let languages):
                _ = try await coordinator.dependencies.firestoreRepository.createProject(userId: userId, name: projectName,
                                                                                         languages: languages,
                                                                                         baseLanguage: languages.last ?? .english,
                                                                                         technologies: selectedTechnologies)
                coordinator.dismissFullScreenCover()
            }
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}

extension SelectTechnologyViewModel {

    enum Context {
        case settings(technologies: [Technology])
        case createProject(projectName: String, languages: [Language])
    }
}
