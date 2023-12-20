//
//  LoginView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

struct RegisterView: View {

    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: "Get your free account")
            GoogleButton(action: viewModel.onLoginWithGoogleTapped)
            AppDivider(with: "OR")
            AppTextField(type: .email, text: $viewModel.email)
            AppButton(style: .fill("Continue with Email", .lightBlue), action: .main(viewModel.onRegisterWithEmailTapped))
            HStack(spacing: 8) {
                Text("Already have an account?")
                    .apply(.medium, size: .M, color: .white)
                AppButton(style: .text("Login"), action: .main(viewModel.onLoginTapped))
            }.frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .padding(16)
        .background(appColor(.black))
        .activitable(viewModel.shouldShowActivityView)
    }
}

#Preview {
    RegisterView(viewModel: .init(coordinator: MockCoordinator()))
}
