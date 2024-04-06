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

    typealias ProfileDeleteWarningCoordinator = Coordinator & SheetActions

    @Published private(set) var state: State = .deletion {
        didSet {
            scrollToPageAction?(state)
        }
    }

    var scrollToPageAction: ((State) -> Void)?

    let informationPageTitle: String = "Action Required"
    let informationPageDescription: String = "As you are currently owning a project, you must either transfer ownership to another user or delete the project before you can delete your account. Owning a project prevents account deletion."
    let informationPageButtonTitle: String = "Understood"

    let deletionPageTitle: String = "Are you sure ?"
    let deletionPageDescription1: String = "Deleting your account will instantly remove you from current projects."
    let deletionPageDescription2: String = "Active subscriptions will be cancelled without the possibility of renewal."
    let deletionPageDescription3: String = "The account deletion process is irreversible, and you will not be able to regain access to your account or its data."
    let deletionPageButtonDeleteAccountTitle: String = "Delete Account"
    let deletionPageButtonCancelTitle: String = "Cancel"

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
