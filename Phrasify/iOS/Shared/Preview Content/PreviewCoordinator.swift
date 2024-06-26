//
//  PreviewCoordinator.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI
import Model
import Domain

final class PreviewCoordinator: Coordinator, StartActions, RootActions, FullScreenCoverActions, ProjectActions, ProfileActions,
                                NavigationActions, SelectLanguageActions, SelectTechnologyActions, PaywallActions,
                                SelectMemberRoleActions, SheetActions, EnterContentKeyActions, ProjectDetailActions {

    var dependencies: Dependencies = MockDependencies.dependencies

    func showLogin() { /*empty*/ }

    func showRegister() { /*empty*/ }

    func showForgetPassword() { /*empty*/ }

    func showSetPassword(email: String) { /*empty*/ }

    func closeForgetPassword() { /*empty*/ }

    func showChangePassword(authenticationProvider: AuthenticationProvider) { /*empty*/ }

    func popToRoot() { /*empty*/ }
    func popView() { /*empty*/ }

    func showProfile() { /*empty*/ }
    func showProfileName(name: String?, surname: String?) { /*empty*/ }
    func presentCreateProject() { /*empty*/ }
    func presentCreateKey(project: Project) { /*empty*/ }
    func dismissFullScreenCover() { /*empty*/ }
    func showProjectDetails(project: Project) { /*empty*/ }
    func showSelectLanguage(name: String) { /*empty*/ }
    func showSelectTechnology(name: String, languages: [Language], baseLanguage: Language) { /*empty*/ }
    func dismiss() { /*empty*/ }
    func dismissSheet() { /*empty*/ }

    func showUploadPhotoDialog(galleryAction: @escaping () -> Void) { /*empty*/ }
    func showProfileDeleteWarning() { /*empty*/ }
    func showProjectSettings(projectUseCase: ProjectUseCase, projectMemberUseCase: ProjectMemberUseCase) { /*empty*/ }
    func showSelectedLanguages(project: Project) { /*empty*/ }
    func showSelectedTechnologies(project: Project) { }
    func showProjectMembers(project: Project, projectMemberUseCase: ProjectMemberUseCase) { /*empty*/ }
    func presentInviteMember(project: Project) { }
    func showSelectMemberRole(email: String, project: Project, user: User) { }
    func showChangeProjectOwner(project: Project) { }
    func showLeaveProjectWarning(project: Project) { }
    func showDeleteProjectWarning(project: Project) { }
    func showSelectMemberRole(member: Member, project: Project) { }
    func showDeleteMemberWarning(project: Project, member: Member) {  }
    func showKeyDetails(key: Key, project: Project, projectMemberUseCase: ProjectMemberUseCase) { }
    func showEnterContentKey(keyId: String, project: Project) { }
    func showEditContentKey(language: Language, key: Key, project: Project) { }
    func showProjectIntegration(project: Project) { }
    func showDeleteKeyWarning(project: Project, key: Key) { }
    func showLeaveProjectInformation() {}
    func showSelectedBaseLanguage(project: Project) {}
    func showSelectBaseLanguage(name: String, languages: [Language]) {}
    func presentPaywall() {}
}
