//
//  SelectTechnologyViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI
import Model
import Domain

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & FullScreenCoverActions & NavigationActions

    @Published var selectedTechnologies: [Technology] = []

    var utility: Utility {
        .init(selectedTechnologies: selectedTechnologies, context: context)
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
                coordinator.dismissFullScreenCover()
                ToastView.showSuccess(message: "Project '\(projectName)' successfully created.")
            }
        } catch {
            if case .createProject = context, let cloudError = ErrorHandler.CloudError(rawValue: error.localizedDescription),
                cloudError == .accessDenied {
                await startTrial()
            } else {
                let errorHandler = ErrorHandler(error: error)
                ToastView.showError(message: errorHandler.localizedDescription)
            }
        }
    }

    @MainActor
    private func startTrial() async {
        guard case .createProject(let projectName, let languages, let baseLanguage) = context else { return }
        do {
            try await coordinator.dependencies.cloudRepository.startTrial(.init())
            try await coordinator.dependencies.cloudRepository.createProject(.init(name: projectName,
                                                                                   languages: languages,
                                                                                   baseLanguage: baseLanguage,
                                                                                   technologies: selectedTechnologies))
            coordinator.dismissFullScreenCover()
            ToastView.showSuccess(message: "Project '\(projectName)' successfully created.")
        } catch {
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }
}
