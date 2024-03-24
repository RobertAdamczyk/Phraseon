//
//  RegisterView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 23.03.24.
//

import SwiftUI

struct RegisterView: View {

    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        ViewThatFits {
            content
            ScrollView(showsIndicators: false) {
                content
            }
        }
        .activitable(viewModel.shouldShowActivityView)
        .navigationTitle("Sign up")
        .applyViewBackground()
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: "Get your free account")
                .padding(.bottom, 16)
            AppleButton(onRequest: viewModel.onLoginWithAppleTapped,
                        onCompletion: viewModel.handleLoginWithApple)
            GoogleButton(action: viewModel.onLoginWithGoogleTapped)
            AppDivider(with: "OR")
            VStack(spacing: 24) {
                AppTextField(type: .email, text: $viewModel.email)
                AppTextField(type: .password, text: $viewModel.password)
                AppTextField(type: .confirmPassword, text: $viewModel.confirmPassword)
            }
            ZStack {
                ValidationView(validationHandler: viewModel.passwordValidationHandler)
                ValidationView(validationHandler: viewModel.emailValidationHandler)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Create Account", .lightBlue), action: .async(viewModel.onRegisterWithEmailTapped))
                HStack(spacing: 8) {
                    Text("Already have an account?")
                        .apply(.medium, size: .M, color: .white)
                    AppButton(style: .text("Login"), action: .main(viewModel.onLoginTapped))
                }
            }
            .padding(.top, 16)
        }
        .frame(maxWidth: 375)
        .scenePadding()
    }
}
