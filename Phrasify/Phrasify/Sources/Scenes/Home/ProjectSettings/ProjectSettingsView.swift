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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("General")
                        .apply(.medium, size: .M, color: .lightGray)
                    Button(action: viewModel.onLanguagesTapped, label: {
                        makeSettingsRow(for: .languages, value: "DE EN PL")
                    })
                    Button(action: viewModel.onTechnologiesTapped, label: {
                        makeSettingsRow(for: .technologies, value: "Kotlin/Swift")
                    })
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("Users and permissions")
                        .apply(.medium, size: .M, color: .lightGray)
                    Button(action: viewModel.onMembersTapped, label: {
                        makeSettingsRow(for: .members, value: "32 Members")
                    })
                    Button(action: viewModel.onOwnerTapped, label: {
                        makeSettingsRow(for: .owner, value: "Robert Adamczyk")
                    })
                }
                VStack(spacing: 16) {
                    AppButton(style: .text("Leave Project"), action: .main(viewModel.onLeaveProjectTapped))
                    AppButton(style: .text("Delete Project"), action: .main(viewModel.onDeleteProjectTapped))
                }
                .padding(.top, 16)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .navigationTitle("Settings")
    }
}

extension ProjectSettingsView {

    private enum SettingsItem {
        case technologies
        case languages
        case members
        case owner

        var imageView: some View {
            switch self {
            case .technologies:
                Image(systemName: "swift")
                    .resizable()
                    .frame(width: 28, height: 24)
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
            }
        }

        var title: String {
            switch self {
            case .technologies: "Technologies"
            case .languages: "Languages"
            case .members: "Members"
            case .owner: "Owner"
            }
        }

        var showChevron: Bool {
            switch self {
            case .technologies, .languages, .members, .owner: true
            }
        }
    }

    @ViewBuilder
    private func makeSettingsRow(for item: SettingsItem, value: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                item.imageView
                    .foregroundStyle(appColor(.white))
            }
            .frame(width: 28)
            VStack(alignment: .leading) {
                Text(item.title)
                    .apply(.regular, size: .S, color: .white)
                Text(value)
                    .apply(.medium, size: .S, color: .lightGray)
            }
            Spacer()
            if item.showChevron {
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
