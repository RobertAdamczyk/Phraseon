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
        VStack(spacing: 16) {
            Button(action: viewModel.onHomeTapped) {
                Label("Home", systemImage: "house.fill")
                    .apply(.bold, size: .L, color: .white)
            }
            Button(action: viewModel.onProfileTapped) {
                Label("Profile", systemImage: "person.fill")
                    .apply(.bold, size: .L, color: .white)
            }
        }
    }
}
