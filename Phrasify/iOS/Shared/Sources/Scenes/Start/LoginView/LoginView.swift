//
//  LoginView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    @FocusState private var focusedField: AppTextField.TType?

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(title: "Login in to Phraseon")
                    AppTextField(type: .email, text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                    AppTextField(type: .password, text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                    AppButton(style: .text("Forget Password?"), action: .main(viewModel.onForgetPasswordTapped))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(16)
            }
            VStack(spacing: 32) {
                if focusedField == nil {
                    AppleButton(onRequest: viewModel.onLoginWithAppleTapped,
                                onCompletion: viewModel.handleLoginWithApple)
                    GoogleButton(action: viewModel.onLoginWithGoogleTapped)
                    AppDivider(with: "OR")
                }
                AppButton(style: .fill("Login", .lightBlue), action:  .async(viewModel.onLoginTapped))
            }
            .padding(16)
        }
        .activitable(viewModel.shouldShowActivityView)
        .toolbarRole(.editor)
        .applyViewBackground()
    }
}

#if DEBUG
#Preview {
    LoginView(viewModel: .init(coordinator: PreviewCoordinator()))
}
#endif
