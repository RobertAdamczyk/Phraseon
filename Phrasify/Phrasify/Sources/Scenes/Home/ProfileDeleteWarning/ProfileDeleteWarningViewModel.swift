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

    typealias ProfileDeleteWarningCoordinator = Coordinator & ProfileActions & NavigationActions & SheetActions

    @Published private(set) var state: State = .deletion {
        didSet {
            scrollToPageAction?(state)
        }
    }

    var scrollToPageAction: ((State) -> Void)?

    private let coordinator: ProfileDeleteWarningCoordinator

    init(coordinator: ProfileDeleteWarningCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor
    func onDeleteAccountTapped() async {
        state = .loading
        do {
            let response = try await coordinator.dependencies.cloudRepository.isUserProjectOwner()
            if response.isOwner {
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
