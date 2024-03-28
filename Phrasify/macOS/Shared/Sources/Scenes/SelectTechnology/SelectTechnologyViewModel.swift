//
//  SelectTechnologyViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI
import Model
import Domain

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & SheetActions & NavigationActions

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

    func onCloseButtonTapped() {
        coordinator.dismissSheet()
    }

    func onTechnologyTapped(_ technology: Technology) {
        guard !selectedTechnologies.contains(technology) else { return }
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
                try await coordinator.dependencies.cloudRepository.setProjectTechnologies(.init(projectId: projectId,
                                                                                                technologies: selectedTechnologies))
                coordinator.popView()
                ToastView.showSuccess(message: "Technologies successfully updated for the project.")
            case .createProject(let projectName, let languages, let baseLanguage):
                try await coordinator.dependencies.cloudRepository.createProject(.init(name: projectName,
                                                                                       languages: languages,
                                                                                       baseLanguage: baseLanguage,
                                                                                       technologies: selectedTechnologies))
                coordinator.dismissSheet()
                ToastView.showSuccess(message: "Project '\(projectName)' successfully created.")
            }
        } catch {
            if case .createProject = context, let cloudError = ErrorHandler.CloudError(rawValue: error.localizedDescription),
                cloudError == .accessDenied {
                // coordinator.presentPaywall()
            } else {
                let errorHandler = ErrorHandler(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
            }
        }
    }
}

extension SelectTechnologyViewModel {

    enum Context { // TODO: Cleanup
        case settings(project: Project)
        case createProject(projectName: String, languages: [Language], baseLanguage: Language)
    }
}

