//
//  StartViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 15.03.24.
//

import SwiftUI

final class StartViewModel: ObservableObject {

    typealias StartCoordinator = Coordinator & StartActions

    private let coordinator: StartCoordinator

    init(coordinator: StartCoordinator) {
        self.coordinator = coordinator
    }

    func showEmpty() {
        coordinator.showEmpty()
    }
}
