//
//  SelectTechnologyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & CreateProjectActions

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

    private let coordinator: SelectTechnologyCoordinator
    private let name: String
    private let languages: [Language]

    init(coordinator: SelectTechnologyCoordinator, name: String, languages: [Language]) {
        self.coordinator = coordinator
        self.name = name
        self.languages = languages
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
            _ = try await coordinator.dependencies.firestoreRepository.createProject(userId: userId, name: name, languages: languages,
                                                                                     technologies: selectedTechnologies)
            coordinator.dismiss()
        } catch {
            ToastView.showError(message: error.localizedDescription)
        }
    }
}

