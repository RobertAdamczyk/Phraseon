//
//  MenuView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 27.03.24.
//

import SwiftUI

struct MenuView: View {

    @StateObject private var viewModel: MenuViewModel

    init(coordinator: MenuViewModel.MenuCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppTitle(title: "Menu")
                .padding(.bottom, 16)
            makeMenuButton(for: .projects, perform: viewModel.onProjectsTapped)
            makeMenuButton(for: .profile, perform: viewModel.onProfileTapped)
            Spacer()
        }
        .padding(16)
    }

    private func makeMenuButton(for menu: MenuItem, perform action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 4) {
                menu.systemImage
                    .frame(width: 28)
                    .foregroundStyle(appColor(.paleOrange))
                Text(menu.label)
                    .lineLimit(1)
                Spacer()
            }
            .apply(.semibold, size: .M, color: .white)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(menu == viewModel.selectedMenuItem ? appColor(.lightGray).opacity(0.5) : .clear)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
