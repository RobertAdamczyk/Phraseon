//
//  SelectTechnologyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & FullScreenCoverActions & NavigationActions

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
        if case .settings(let project) = context {
            selectedTechnologies = project.technologies
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
        do {
            switch context {
            case .settings(let project):
                guard let projectId = project.id else { return }
                try await coordinator.dependencies.cloudRepository.setProjectTechnologies(projectId: projectId, technologies: selectedTechnologies)
                coordinator.popView()
            case .createProject(let projectName, let languages):
                try await coordinator.dependencies.cloudRepository.createProject(name: projectName,
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
        case settings(project: Project)
        case createProject(projectName: String, languages: [Language])
    }
}
