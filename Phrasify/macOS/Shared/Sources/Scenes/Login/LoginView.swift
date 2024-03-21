//
//  LoginView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 16.03.24.
//

import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ViewThatFits {
            content
            ScrollView(showsIndicators: false) {
                content
            }
        }
        .navigationTitle("Login")
        .applyViewBackground()
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            Spacer()
            AppTitle(title: "Login in to Phraseon")
                .padding(.bottom, 16)
            AppTextField(type: .email, text: $viewModel.email)
            AppTextField(type: .password, text: $viewModel.password)
            AppButton(style: .text("Forget Password?"), action: .main({}))
                .frame(maxWidth: .infinity, alignment: .trailing)
            AppButton(style: .fill("Login", .lightBlue), action: .async(viewModel.onLoginTapped))
            AppDivider(with: "OR")
            GoogleButton(action: viewModel.onLoginWithGoogleTapped)
            AppleButton(onRequest: { _ in

            }) { _ in

            }
            Spacer()
        }
        .frame(maxWidth: 375)
        .scenePadding()
        .activitable(viewModel.shouldShowActivityView)
    }
}
