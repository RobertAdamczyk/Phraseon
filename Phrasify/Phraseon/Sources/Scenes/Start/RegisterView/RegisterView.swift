//
//  LoginView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 11.12.23.
//

import SwiftUI

struct RegisterView: View {

    @ObservedObject var viewModel: RegisterViewModel

    @FocusState private var focusedField: AppTextField.TType?

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(title: "Get your free account")
                    if focusedField == nil {
                        GoogleButton(action: viewModel.onLoginWithGoogleTapped)
                        AppDivider(with: "OR")
                    }
                    AppTextField(type: .email, text: $viewModel.email)
                        .focused($focusedField, equals: .email)
                    ValidationView(validationHandler: viewModel.emailValidationHandler)
                }
                .padding(16)
                .animation(.easeInOut, value: focusedField)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Continue with Email", .lightBlue), action: .main(viewModel.onRegisterWithEmailTapped))
                if focusedField == nil {
                    HStack(spacing: 8) {
                        Text("Already have an account?")
                            .apply(.medium, size: .M, color: .white)
                        AppButton(style: .text("Login"), action: .main(viewModel.onLoginTapped))
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
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
    RegisterView(viewModel: .init(coordinator: MockCoordinator()))
}
#endif
