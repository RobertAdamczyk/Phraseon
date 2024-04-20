//
//  ProjectSettingsView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 04.01.24.
//

import SwiftUI

struct ProjectSettingsView: View {

    @ObservedObject var viewModel: ProjectSettingsViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("General")
                            .apply(.medium, size: .M, color: .lightGray)
                        Button(action: viewModel.onIntegrationTapped, label: {
                            makeSettingsRow(for: .integration, value: "How to integrate ?")
                        })
                        Button(action: viewModel.onLanguagesTapped, label: {
                            makeSettingsRow(for: .languages, value: viewModel.project.languages.joined,
                                            showChevron: viewModel.member?.hasPermissionToChangeLanguages == true)
                        })
                        .disabled(!(viewModel.member?.hasPermissionToChangeLanguages == true))
                        Button(action: viewModel.onBaseLanguageTapped, label: {
                            makeSettingsRow(for: .baseLanguage, value: viewModel.project.baseLanguage.localizedTitle,
                                            showChevron: viewModel.member?.hasPermissionToChangeLanguages == true)
                        })
                        .disabled(!(viewModel.member?.hasPermissionToChangeLanguages == true))
                        Button(action: viewModel.onTechnologiesTapped, label: {
                            makeSettingsRow(for: .technologies, value: viewModel.project.technologies.joined,
                                            showChevron: viewModel.member?.hasPermissionToChangeTechnologies == true)
                        })
                        .disabled(!(viewModel.member?.hasPermissionToChangeTechnologies == true))
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Users and permissions")
                            .apply(.medium, size: .M, color: .lightGray)
                        Button(action: viewModel.onMembersTapped, label: {
                            makeSettingsRow(for: .members, value: "\(viewModel.project.members.count) Members")
                        })
                        if viewModel.member?.hasPermissionToChangeOwner == true {
                            Button(action: viewModel.onOwnerTapped, label: {
                                makeSettingsRow(for: .owner, value: viewModel.utility.ownerName)
                            })
                        }
                    }

                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Leave Project", .lightBlue), action: .main(viewModel.onLeaveProjectTapped))
                if viewModel.member?.hasPermissionToDeleteProject == true {
                    AppButton(style: .text("Delete Project"), action: .main(viewModel.onDeleteProjectTapped))
                }
            }
            .padding(16)
        }
        .navigationTitle("Settings")
        .applyViewBackground()
    }
}
