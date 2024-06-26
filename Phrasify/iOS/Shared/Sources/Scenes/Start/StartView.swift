//
//  StartView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

struct StartView: View {

    @StateObject private var viewModel: StartViewModel

    init(coordinator: StartViewModel.StartCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Text("Phraseon")
                    .apply(.bold, size: .H2, color: .white)
                Text("Manage and translate easily")
                    .apply(.medium, size: .L, color: .white)
            }
            Spacer()
            VStack(spacing: 16) {
                AppButton(style: .fill("Sign in", .paleOrange), action: .main(viewModel.onSignInTapped))
                AppButton(style: .fill("Sign up", .lightBlue), action: .main(viewModel.onSignUpTapped))
            }
        }
        .padding(16)
        .applyViewBackground()
    }
}

#if DEBUG
#Preview {
    StartView(coordinator: StartCoordinator(parentCoordinator: PreviewCoordinator()))
}
#endif
