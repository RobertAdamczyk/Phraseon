//
//  ProfileDeleteWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 03.01.24.
//

import SwiftUI

final class ProfileDeleteWarningViewModel: ObservableObject {

    enum State: String {
        case deletion
        case information
        case loading
    }

    typealias ProfileDeleteWarningCoordinator = Coordinator & ProfileActions

    @Published private(set) var state: State = .deletion {
        didSet {
            scrollToPageAction?(state)
        }
    }

    var scrollToPageAction: ((State) -> Void)?

    private let coordinator: ProfileDeleteWarningCoordinator

    private var userId: UserID? {
        coordinator.dependencies.authenticationRepository.currentUser?.uid
    }

    init(coordinator: ProfileDeleteWarningCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onDeleteAccountTapped() async {
        guard let userId else { return }
        state = .loading
        do {
            let isOwner = try await coordinator.dependencies.cloudRepository.isUserProjectOwner(userId: userId)
            if isOwner {
                state = .information
            } else {
                try await coordinator.dependencies.authenticationRepository.deleteUser()
                coordinator.dismissSheet()
            }
        } catch {
            coordinator.dismissSheet()
            ToastView.showError(message: error.localizedDescription)
        }
    }

    func onUnderstoodTapped() {
        coordinator.dismissSheet()
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}


