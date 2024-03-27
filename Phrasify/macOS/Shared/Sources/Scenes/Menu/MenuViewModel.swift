//
//  MenuViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI
import Common

final class MenuViewModel: ObservableObject {

    typealias MenuCoordinator = Coordinator & MenuActions

    @Published var selectedMenuItem: MenuItem?

    private let coordinator: MenuCoordinator
    private let cancelBag = CancelBag()

    init(coordinator: MenuCoordinator) {
        self.coordinator = coordinator
        setupMenuItemSubscription()
    }

    func onProjectsTapped() {
        coordinator.showProjects()
    }

    func onProfileTapped() {
        coordinator.showProfile()
    }

    private func setupMenuItemSubscription() {
        (coordinator as? HomeCoordinator)?.$selectedMenuItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] menuItem in
                self?.selectedMenuItem = menuItem
            })
            .store(in: cancelBag)
    }
}


