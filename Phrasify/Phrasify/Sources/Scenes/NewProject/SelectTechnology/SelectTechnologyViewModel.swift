//
//  SelectTechnologyViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

final class SelectTechnologyViewModel: ObservableObject {

    typealias SelectTechnologyCoordinator = Coordinator & NewProjectActions

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

    init(coordinator: SelectTechnologyCoordinator) {
        self.coordinator = coordinator
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

    func onPrimaryButtonTapped() {

    }
}

