//
//  RootCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject, Coordinator {

    @Published var navigationViews: [NavigationView] = []
    @Published var presentedFullScreenCover: FullScreenCover?
    @Published var presentedSheet: Sheet?
    @Published var confirmationDialog: ConfirmationDialog.Model? // TODO: Delete?

    var isLoggedIn: Bool? { dependencies.authenticationRepository.isLoggedIn }

    var dependencies: Dependencies

    private var cancelBag = CancelBag()

    init() {
        dependencies = .init(authenticationRepository: .init(), firestoreRepository: .init(), cloudRepository: .init(),
                             storageRepository: .init())
        setupLoginSubscription()
    }

    private func setupLoginSubscription() {
        dependencies.authenticationRepository.$isLoggedIn.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: cancelBag)
    }
}

extension RootCoordinator: NavigationActions {

    func popToRoot() {
        navigationViews.removeAll()
    }

    func popView() {
        navigationViews.removeLast()
    }
}

extension RootCoordinator: FullScreenCoverActions {

    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
}

extension RootCoordinator: ConfirmationDialogActions {

    func showUploadPhotoDialog(galleryAction: @escaping () -> Void) {
        confirmationDialog = .selectImage(galleryAction)
    }
}

extension RootCoordinator: RootActions {

    func showProfile() {
        let viewModel = ProfileViewModel(coordinator: self)
        let view: NavigationView = .profile(viewModel: viewModel)
        navigationViews.append(view)
    }

    func presentCreateProject() {
        presentedFullScreenCover = .createProject
    }

    func showProjectDetails(project: Project) {
        let viewModel = ProjectDetailViewModel(coordinator: self, project: project)
        let view: NavigationView = .projectDetails(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension RootCoordinator: ProfileActions {

    func showProfileName(name: String, surname: String) {
        let viewModel = ProfileNameViewModel(name: name, surname: surname, coordinator: self)
        let view: NavigationView = .profileName(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showChangePassword(authenticationProvider: AuthenticationProvider) {
        let viewModel = ChangePasswordViewModel(authenticationProvider: authenticationProvider, coordinator: self)
        let view: NavigationView = .changePassword(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showProfileDeleteWarning() {
        let viewModel = ProfileDeleteWarningViewModel(coordinator: self)
        let sheet: Sheet = .profileDeleteWarning(viewModel: viewModel)
        presentedSheet = sheet
    }

    func dismissSheet() {
        presentedSheet = nil
    }
}

extension RootCoordinator: ProjectActions {

    func presentCreateKey(project: Project) {
        presentedFullScreenCover = .createKey(project)
    }

    func showProjectSettings(project: Project) {
        let viewModel = ProjectSettingsViewModel(coordinator: self, project: project)
        let view: NavigationView = .projectSettings(viewModel: viewModel)
        navigationViews.append(view)
    }
}

extension RootCoordinator: SelectLanguageActions {

    func showSelectedLanguages(project: Project) {
        let viewModel = SelectLanguageViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedLanguages(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectLanguage(name: String) {
        // empty implementation
    }
}

extension RootCoordinator: SelectTechnologyActions {

    func showSelectedTechnologies(project: Project) {
        let viewModel = SelectTechnologyViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedTechnologies(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectTechnology(name: String, languages: [Language]) {
        // empty implementation
    }
}

extension RootCoordinator {

    enum NavigationView: Identifiable, Hashable, Equatable {
        case profile(viewModel: ProfileViewModel)
        case profileName(viewModel: ProfileNameViewModel)
        case changePassword(viewModel: ChangePasswordViewModel)
        case projectDetails(viewModel: ProjectDetailViewModel)
        case projectSettings(viewModel: ProjectSettingsViewModel)
        case selectedLanguages(viewModel: SelectLanguageViewModel)
        case selectedTechnologies(viewModel: SelectTechnologyViewModel)

        static func == (lhs: RootCoordinator.NavigationView, rhs: RootCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .profile: return "001"
            case .projectDetails: return "002"
            case .profileName: return "003"
            case .changePassword: return "004"
            case .projectSettings: return "005"
            case .selectedLanguages: return "006"
            case .selectedTechnologies: return "007"
            }
        }
    }

    enum FullScreenCover: Identifiable {
        case createProject
        case createKey(Project)

        var id: String {
            switch self {
            case .createProject: "001"
            case .createKey: "002"
            }
        }
    }

    enum Sheet: Identifiable {
        case profileDeleteWarning(viewModel: ProfileDeleteWarningViewModel)

        var id: String {
            switch self {
            case .profileDeleteWarning: "001"
            }
        }
    }
}
