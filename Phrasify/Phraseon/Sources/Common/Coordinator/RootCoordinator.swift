//
//  RootCoordinator.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject, Coordinator {

    @Published var navigationViews: [NavigationView] = []
    @Published var presentedFullScreenCover: FullScreenCover?
    @Published var presentedSheet: Sheet?

    @Published private(set) var updateInfo: AppUpdateHandler.UpdateInfo?
    @Published private(set) var isLoggedIn: Bool?

    var dependencies: Dependencies

    private let appUpdateHandler: AppUpdateHandler

    init() {
        let authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
        let firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl()
        let cloudRepository: CloudRepository = CloudRepositoryImpl()
        let storageRepository: StorageRepository = StorageRepositoryImpl()
        let storeKitRepository: StoreKitRepository = StoreKitRepositoryImpl()
        let userDomain: UserDomain = .init(firestoreRepository: firestoreRepository, authenticationRepository: authenticationRepository)
        let searchRepository: SearchRepository = SearchRepositoryImpl()
        let configurationRepository: ConfigurationRepository = .init()
        dependencies = .init(authenticationRepository: authenticationRepository,
                             firestoreRepository: firestoreRepository,
                             cloudRepository: cloudRepository,
                             storageRepository: storageRepository,
                             storeKitRepository: storeKitRepository,
                             userDomain: userDomain,
                             searchRepository: searchRepository,
                             configurationRepository: configurationRepository)
        appUpdateHandler = .init(configurationRepository: configurationRepository)
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        dependencies.authenticationRepository.isLoggedInPublisher
            .assign(to: &$isLoggedIn)
        appUpdateHandler.$updateInfo
            .assign(to: &$updateInfo)
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

extension RootCoordinator: SheetActions {

    func dismissSheet() {
        presentedSheet = nil
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
}

extension RootCoordinator: PaywallActions {

    func presentPaywall() {
        presentedFullScreenCover = .paywall
    }
}

extension RootCoordinator: ProjectActions {

    func presentCreateKey(project: Project) {
        presentedFullScreenCover = .createKey(project)
    }

    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = ProjectSettingsViewModel(coordinator: self,
                                                 projectUseCase: projectUseCase,
                                                 projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .projectSettings(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = ProjectMembersViewModel(coordinator: self, project: project, projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .projectMembers(viewModel: viewModel)
        navigationViews.append(view)
    }

    func presentInviteMember(project: Project) {
        let fullScreenCover: FullScreenCover = .inviteMember(project)
        presentedFullScreenCover = fullScreenCover
    }

    func showChangeProjectOwner(project: Project) {
        let viewModel = ChangeProjectOwnerViewModel(coordinator: self, project: project)
        let view: NavigationView = .changeProjectOwner(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showLeaveProjectWarning(project: Project) {
        let viewModel = LeaveProjectWarningViewModel(coordinator: self, project: project)
        let sheet: Sheet = .leaveProjectWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showLeaveProjectInformation() {
        let viewModel = LeaveProjectInformationViewModel(coordinator: self)
        let sheet: Sheet = .leaveProjectInformation(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showDeleteProjectWarning(project: Project) {
        let viewModel = DeleteProjectWarningViewModel(coordinator: self, project: project)
        let sheet: Sheet = .deleteProjectWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showDeleteMemberWarning(project: Project, member: Member) {
        let viewModel = DeleteMemberWarningViewModel(coordinator: self, project: project, member: member)
        let sheet: Sheet = .deleteMemberWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }

    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) {
        let viewModel = KeyDetailViewModel(coordinator: self, key: key, project: project, projectMemberUseCase: projectMemberUseCase)
        let view: NavigationView = .keyDetail(viewModel: viewModel)
        self.navigationViews.append(view)
    }

    func showProjectIntegration(project: Project) {
        let viewModel = ProjectIntegrationViewModel(coordinator: self, project: project)
        let view: NavigationView = .projectIntegration(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showDeleteKeyWarning(project: Project, key: Key) {
        let viewModel = DeleteKeyWarningViewModel(coordinator: self, project: project, key: key)
        let sheet: Sheet = .deleteKeyWarning(viewModel: viewModel)
        self.presentedSheet = sheet
    }
}

extension RootCoordinator: EnterContentKeyActions {

    func showEditContentKey(language: Language, key: Key, project: Project) {
        let viewModel = EnterContentKeyViewModel(coordinator: self, project: project, context: .edit(key: key, language: language))
        let view: NavigationView = .editContentKey(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showEnterContentKey(keyId: String, project: Project) {
        // empty implementation
    }
}

extension RootCoordinator: SelectMemberRoleActions {

    func showSelectMemberRole(member: Member, project: Project) {
        let viewModel = SelectMemberRoleViewModel(coordinator: self, project: project, context: .members(member: member))
        let view: NavigationView = .selectMemberRole(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectMemberRole(email: String, project: Project, user: User) {
        // empty implementation
    }
}

extension RootCoordinator: SelectLanguageActions {

    func showSelectedLanguages(project: Project) {
        let viewModel = SelectLanguageViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedLanguages(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectedBaseLanguage(project: Project) {
        let viewModel = SelectBaseLanguageViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectBaseLanguage(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectLanguage(name: String) {
        // empty implementation
    }

    func showSelectBaseLanguage(name: String, languages: [Language]) {
        // empty implementation
    }
}

extension RootCoordinator: SelectTechnologyActions {

    func showSelectedTechnologies(project: Project) {
        let viewModel = SelectTechnologyViewModel(coordinator: self, context: .settings(project: project))
        let view: NavigationView = .selectedTechnologies(viewModel: viewModel)
        navigationViews.append(view)
    }

    func showSelectTechnology(name: String, languages: [Language], baseLanguage: Language) {
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
        case projectMembers(viewModel: ProjectMembersViewModel)
        case changeProjectOwner(viewModel: ChangeProjectOwnerViewModel)
        case selectMemberRole(viewModel: SelectMemberRoleViewModel)
        case keyDetail(viewModel: KeyDetailViewModel)
        case editContentKey(viewModel: EnterContentKeyViewModel)
        case projectIntegration(viewModel: ProjectIntegrationViewModel)
        case selectBaseLanguage(viewModel: SelectBaseLanguageViewModel)

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
            case .projectMembers: return "008"
            case .changeProjectOwner: return "009"
            case .selectMemberRole: return "010"
            case .keyDetail: return "011"
            case .editContentKey: return "012"
            case .projectIntegration: return "013"
            case .selectBaseLanguage: return "014"
            }
        }
    }

    enum FullScreenCover: Identifiable {
        case createProject
        case createKey(Project)
        case inviteMember(Project)
        case paywall

        var id: String {
            switch self {
            case .createProject: "001"
            case .createKey: "002"
            case .inviteMember: "003"
            case .paywall: "004"
            }
        }
    }

    enum Sheet: Identifiable {
        case profileDeleteWarning(viewModel: ProfileDeleteWarningViewModel)
        case leaveProjectWarning(viewModel: LeaveProjectWarningViewModel)
        case leaveProjectInformation(viewModel: LeaveProjectInformationViewModel)
        case deleteProjectWarning(viewModel: DeleteProjectWarningViewModel)
        case deleteMemberWarning(viewModel: DeleteMemberWarningViewModel)
        case deleteKeyWarning(viewModel: DeleteKeyWarningViewModel)

        var id: String {
            switch self {
            case .profileDeleteWarning: "001"
            case .leaveProjectWarning: "002"
            case .deleteProjectWarning: "003"
            case .deleteMemberWarning: "004"
            case .deleteKeyWarning: "005"
            case .leaveProjectInformation: "006"
            }
        }
    }
}
