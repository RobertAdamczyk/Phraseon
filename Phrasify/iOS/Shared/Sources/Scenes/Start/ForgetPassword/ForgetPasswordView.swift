//
//  ForgetPasswordView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct ForgetPasswordView: View {

    @ObservedObject var viewModel: ForgetPasswordViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(title: "Forget Password?",
                             subtitle: "Type your email address and we will send you a link to reset your password.")
                    AppTextField(type: .email, text: $viewModel.email)
                    ValidationView(validationHandler: viewModel.emailValidationHandler)
                }
                .padding(16)
            }
            AppButton(style: .fill("Send Email", .lightBlue), action: .async(viewModel.onSendEmailTapped))
                .padding(16)
        }
        .toolbarRole(.editor)
        .applyViewBackground()
    }
}

#if DEBUG
#Preview {
    ForgetPasswordView(viewModel: .init(coordinator: PreviewCoordinator()))
}
#endif
