//
//  HomeView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(coordinator: HomeViewModel.HomeCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack {
            Text("Home").onTapGesture(perform: viewModel.testLogout)
        }
    }
}
