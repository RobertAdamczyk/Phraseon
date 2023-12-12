//
//  LoginView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 11.12.23.
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
            AppButton(style: .fill("Login", .lightBlue), action: .main(viewModel.onLoginTapped))
            AppDivider()
            Button(action: viewModel.onLoginWithGoogleTapped, label: {
                Image(.iosDarkRdCtn)
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            Spacer()
        }
        .padding(16)
        .background(appColor(.black))
    }
}

#Preview {
    LoginView(viewModel: .init(coordinator: MockCoordinator()))
}
