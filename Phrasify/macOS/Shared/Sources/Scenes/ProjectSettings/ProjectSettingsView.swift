//
//  ProjectSettingsView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 14.04.24.
//

import SwiftUI

struct ProjectSettingsView: View {

    @ObservedObject var viewModel: ProjectSettingsViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("General")
                            .apply(.medium, size: .M, color: .lightGray)
                        Button(action: viewModel.onIntegrationTapped, label: {
                            makeSettingsRow(for: .integration, value: "How to integrate ?")
                        })
                        .buttonStyle(.plain)
                        Button(action: viewModel.onLanguagesTapped, label: {
                            makeSettingsRow(for: .languages, value: viewModel.project.languages.joined,
                                            showChevron: viewModel.member?.hasPermissionToChangeLanguages == true)
                        })
                        .buttonStyle(.plain)
                        .disabled(!(viewModel.member?.hasPermissionToChangeLanguages == true))
                        Button(action: viewModel.onBaseLanguageTapped, label: {
                            makeSettingsRow(for: .baseLanguage, value: viewModel.project.baseLanguage.localizedTitle,
                                            showChevron: viewModel.member?.hasPermissionToChangeLanguages == true)
                        })
                        .buttonStyle(.plain)
                        .disabled(!(viewModel.member?.hasPermissionToChangeLanguages == true))
                        Button(action: viewModel.onTechnologiesTapped, label: {
                            makeSettingsRow(for: .technologies, value: viewModel.project.technologies.joined,
                                            showChevron: viewModel.member?.hasPermissionToChangeTechnologies == true)
                        })
                        .buttonStyle(.plain)
                        .disabled(!(viewModel.member?.hasPermissionToChangeTechnologies == true))
                    }
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Users and permissions")
                            .apply(.medium, size: .M, color: .lightGray)
                        Button(action: viewModel.onMembersTapped, label: {
                            makeSettingsRow(for: .members, value: "\(viewModel.project.members.count) Members")
                        })
                        .buttonStyle(.plain)
                        if viewModel.member?.hasPermissionToChangeOwner == true {
                            Button(action: viewModel.onOwnerTapped, label: {
                                makeSettingsRow(for: .owner, value: viewModel.utility.ownerName)
                            })
                            .buttonStyle(.plain)
                        }
                    }

                }
                .padding(32)
            }
            HStack(spacing: 16) {
                Spacer()
                if viewModel.member?.hasPermissionToDeleteProject == true {
                    AppButton(style: .fill("Delete Project", .lightGray), action: .main(viewModel.onDeleteProjectTapped))
                }
                AppButton(style: .fill("Leave Project", .lightBlue), action: .main(viewModel.onLeaveProjectTapped))
            }
            .padding(32)
        }
        .navigationTitle("Settings")
        .applyViewBackground()
    }
}
