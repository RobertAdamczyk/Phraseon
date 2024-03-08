//
//  ProfileDeleteWarningViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 03.01.24.
//

import SwiftUI
import Domain

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
                ToastView.showSuccess(message: "Your account has been successfully deleted. We're sorry to see you go.")
            }
        } catch {
            coordinator.dismissSheet()
            let errorHandler = ErrorHandler(error: error)
            ToastView.showError(message: errorHandler.localizedDescription)
        }
    }

    func onUnderstoodTapped() {
        coordinator.dismissSheet()
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}
