//
//  RootCoordinator+RootView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

extension RootCoordinator {

    struct RootView: View {

        @StateObject private var rootCoordinator: RootCoordinator = .init()

        var body: some View {
            ZStack {
                if rootCoordinator.isLoggedIn == true {
                    NavigationStack(path: $rootCoordinator.navigationViews) {
                        HomeView(coordinator: rootCoordinator)
                            .navigationDestination(for: RootCoordinator.NavigationView.self) {
                                switch $0 {
                                case .profile(let viewModel): ProfileView(viewModel: viewModel)
                                case .profileName(let viewModel): ProfileNameView(viewModel: viewModel)
                                case .projectDetails(let viewModel): ProjectDetailView(viewModel: viewModel)
                                case .changePassword(let viewModel): ChangePasswordView(viewModel: viewModel)
                                case .projectSettings(let viewModel): ProjectSettingsView(viewModel: viewModel)
                                case .selectedLanguages(let viewModel): SelectLanguageView(viewModel: viewModel)
                                case .selectedTechnologies(let viewModel): SelectTechnologyView(viewModel: viewModel)
                                case .projectMembers(let viewModel): ProjectMembersView(viewModel: viewModel)
                                case .changeProjectOwner(let viewModel): ChangeProjectOwnerView(viewModel: viewModel)
                                case .selectMemberRole(let viewModel): SelectMemberRole(viewModel: viewModel)
                                case .keyDetail(let viewModel): KeyDetailView(viewModel: viewModel)
                                case .editContentKey(let viewModel): EnterContentKeyView(viewModel: viewModel)
                                case .projectIntegration(let viewModel): ProjectIntegrationView(viewModel: viewModel)
                                case .selectBaseLanguage(let viewModel): SelectBaseLanguageView(viewModel: viewModel)
                                }
                            }
                    }
                    .fullScreenCover(item: $rootCoordinator.presentedFullScreenCover) {
                        switch $0 {
                        case .createProject: CreateProjectCoordinator.RootView(parentCoordinator: rootCoordinator)
                        case .createKey(let project): CreateKeyCoordinator.RootView(parentCoordinator: rootCoordinator, project: project)
                        case .inviteMember(let project): InviteMemberCoordinator.RootView(parentCoordinator: rootCoordinator, project: project)
                        case .paywall: PaywallCoordinator.RootView(parentCoordinator: rootCoordinator)
                        }
                    }
                    .sheet(item: $rootCoordinator.presentedSheet) {
                        switch $0 {
                        case .profileDeleteWarning(let viewModel): ProfileDeleteWarningView(viewModel: viewModel)
                        case .leaveProjectWarning(let viewModel): StandardWarningView(viewModel: viewModel)
                        case .leaveProjectInformation(let viewModel): StandardInformationView(viewModel: viewModel)
                        case .deleteProjectWarning(let viewModel): StandardWarningView(viewModel: viewModel)
                        case .deleteMemberWarning(let viewModel): StandardWarningView(viewModel: viewModel)
                        case .deleteKeyWarning(let viewModel): StandardWarningView(viewModel: viewModel)
                        }
                    }
                    .onDisappear(perform: rootCoordinator.popToRoot)
                } else if rootCoordinator.isLoggedIn == false {
                    StartCoordinator.RootView(parentCoordinator: rootCoordinator)
                }
            }
        }
    }
}
