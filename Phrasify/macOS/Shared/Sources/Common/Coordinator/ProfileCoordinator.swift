//
//  ProfileCoordinator.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI
import Model

final class ProfileCoordinator: Coordinator, ObservableObject {

    typealias ParentCoordinator = Coordinator

    @Published var navigationViews: [NavigationView] = []
    @Published var presentedSheet: Sheet?

    var dependencies: Dependencies {
        parentCoordinator.dependencies
    }

    private let parentCoordinator: ParentCoordinator

    init(parentCoordinator: ParentCoordinator) {
        self.parentCoordinator = parentCoordinator
    }
}

extension ProfileCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension ProfileCoordinator: SheetActions {

    func dismissSheet() {
        presentedSheet = nil
    }
}

extension ProfileCoordinator: ProfileActions {

    func showProfileName(name: String?, surname: String?) {
        let viewModel = ProfileNameViewModel(name: name, surname: surname, coordinator: self)
        let sheet: Sheet = .profileName(viewModel: viewModel)
        self.presentedSheet = sheet
    }
    
    func showChangePassword(authenticationProvider: AuthenticationProvider) {
        let viewModel = ChangePasswordViewModel(authenticationProvider: authenticationProvider, coordinator: self)
        let sheet: Sheet = .changePassword(viewModel: viewModel)
        self.presentedSheet = sheet
    }
    
    func showProfileDeleteWarning() {
        let viewModel = ProfileDeleteWarningViewModel(coordinator: self)
        let sheet: Sheet = .profileDeleteWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }
}

extension ProfileCoordinator {

    enum NavigationView {
        case empty
    }

    enum Sheet: Identifiable {
        case profileDeleteWarning(viewModel: ProfileDeleteWarningViewModel)
        case profileName(viewModel: ProfileNameViewModel)
        case changePassword(viewModel: ChangePasswordViewModel)

        var id: String {
            switch self {
            case .profileDeleteWarning: return "001"
            case .profileName: return "002"
            case .changePassword: return "003"
            }
        }
    }
}
