//
//  MenuViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI

final class MenuViewModel: ObservableObject {

    typealias MenuCoordinator = Coordinator

    private let coordinator: MenuCoordinator

    init(coordinator: MenuCoordinator) {
        self.coordinator = coordinator
    }

    func onHomeTapped() {

    }

    func onProfileTapped() {

    }
}


