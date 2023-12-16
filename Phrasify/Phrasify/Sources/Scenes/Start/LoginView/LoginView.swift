//
//  LoginView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Login in to Phrasify")
                .apply(.bold, size: .H1, color: .white)
            AppTextField(type: .email, text: $viewModel.email)
            AppTextField(type: .password, text: $viewModel.password)
            AppButton(style: .text("Forget Password?"), action: .main(viewModel.onForgetPasswordTapped))
            AppButton(style: .fill("Login", .lightBlue), action:  .async(viewModel.onLoginTapped))
            AppDivider(with: "OR")
            GoogleButton(action: viewModel.onLoginWithGoogleTapped)
            Spacer()
        }
        .padding(16)
        .background(appColor(.black))
        .activitable(viewModel.shouldShowActivityView)
    }
}

#Preview {
    LoginView(viewModel: .init(coordinator: MockCoordinator()))
}
