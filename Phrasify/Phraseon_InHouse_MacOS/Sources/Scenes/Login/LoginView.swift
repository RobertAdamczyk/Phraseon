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
        ScrollView {
            VStack(spacing: 32) {
                AppTitle(title: "Login in to Phraseon")
                AppTextField(type: .email, text: $viewModel.email)
                AppTextField(type: .password, text: $viewModel.password)
                AppButton(style: .fill("Login", .lightBlue), action: .main({}))
                AppDivider(with: "OR")
            }
            .frame(maxWidth: 400)
            .scenePadding()
        }
        .navigationTitle("Login")
        .applyViewBackground()
    }
}
