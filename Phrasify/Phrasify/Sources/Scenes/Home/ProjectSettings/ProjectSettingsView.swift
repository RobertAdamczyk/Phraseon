//
//  ProjectSettingsView.swift
//  Phrasify
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
                                makeSettingsRow(for: .owner, value: "Robert Adamczyk")
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
    }
}

extension ProjectSettingsView {

    private enum SettingsItem {
        case technologies
        case languages
        case baseLanguage
        case members
        case owner
        case integration

        var imageView: some View {
            switch self {
            case .technologies:
                Image(systemName: "swift")
                    .resizable()
                    .frame(width: 28, height: 24)
            case .baseLanguage:
                Image(systemName: "text.bubble.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
            case .languages:
                Image(systemName: "globe")
                    .resizable()
                    .frame(width: 28, height: 28)
            case .members:
                Image(systemName: "person.2.fill")
                    .resizable()
                    .frame(width: 28, height: 20)
            case .owner:
                Image(systemName: "person.badge.key.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
            case .integration:
                Image(systemName: "doc.badge.gearshape.fill")
                    .resizable()
                    .frame(width: 24, height: 28)
            }
        }

        var title: String {
            switch self {
            case .technologies: "Technologies"
            case .baseLanguage: "Base Language"
            case .languages: "Languages"
            case .members: "Members"
            case .owner: "Owner"
            case .integration: "Integration"
            }
        }
    }

    @ViewBuilder
    private func makeSettingsRow(for item: SettingsItem, value: String, showChevron: Bool = true) -> some View {
        HStack(spacing: 16) {
            ZStack {
                item.imageView
                    .foregroundStyle(appColor(.black))
            }
            .frame(width: 28, height: 28)
            .padding(4)
            .background {
                appColor(.lightBlue)
                    .clipShape(.rect(cornerRadius: 4))
            }
            VStack(alignment: .leading) {
                Text(item.title)
                    .apply(.regular, size: .S, color: .white)
                Text(value)
                    .apply(.medium, size: .S, color: .lightGray)
                    .lineLimit(1)
            }
            Spacer()
            if showChevron {
                Image(systemName: "chevron.forward")
                    .apply(.bold, size: .L, color: .paleOrange)
            }
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background {
            Rectangle()
                .fill(appColor(.darkGray))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
