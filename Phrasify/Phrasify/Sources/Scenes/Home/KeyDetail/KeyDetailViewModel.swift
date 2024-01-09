//
//  KeyDetailViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

final class KeyDetailViewModel: ObservableObject {

    typealias KeyDetailCoordinator = Coordinator

    let project: Project
    let key: Key
    private let coordinator: KeyDetailCoordinator

    init(coordinator: KeyDetailCoordinator, key: Key, project: Project) {
        self.coordinator = coordinator
        self.key = key
        self.project = project
    }
}

