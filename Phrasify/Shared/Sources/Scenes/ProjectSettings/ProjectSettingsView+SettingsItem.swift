//
//  ProjectSettingsView+SettingsItem.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.04.24.
//

import SwiftUI

extension ProjectSettingsView {

    enum SettingsItem {
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
    func makeSettingsRow(for item: SettingsItem, value: String, showChevron: Bool = true) -> some View {
        HStack(spacing: 16) {
            ZStack {
                item.imageView
                    .foregroundStyle(appColor(.white))
            }
            .frame(width: 28, height: 28)
            VStack(alignment: .leading, spacing: 4) {
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
        .applyCellBackground()
    }
}
