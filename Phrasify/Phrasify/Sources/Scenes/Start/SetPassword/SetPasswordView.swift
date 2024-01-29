//
//  SetPassword.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct SetPasswordView: View {

    @ObservedObject var viewModel: SetPasswordViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(title: "Set your password")
                    AppTextField(type: .password, text: $viewModel.password)
                    AppTextField(type: .confirmPassword, text: $viewModel.confirmPassword)
                    ValidationView(validationHandler: viewModel.passwordValidationHandler)
                }
                .padding(16)
            }
            AppButton(style: .fill("Create an Account", .lightBlue), 
                      action: .async(viewModel.onCreateAccountTapped))
            .padding(16)
        }
        .toolbarRole(.editor)
        .applyViewBackground()
    }
}

#Preview {
    SetPasswordView(viewModel: .init(email: "", coordinator: MockCoordinator()))
}
