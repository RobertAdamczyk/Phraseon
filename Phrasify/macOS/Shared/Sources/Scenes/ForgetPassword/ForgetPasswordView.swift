//
//  ForgetPasswordView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 24.03.24.
//

import SwiftUI

struct ForgetPasswordView: View {

    @ObservedObject var viewModel: ForgetPasswordViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ScrollView {
                    content
                }
                Spacer()
                HStack(spacing: 16) {
                    Spacer()
                    AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelTapped))
                    AppButton(style: .fill("Send Email", .lightBlue), action: .async(viewModel.onSendEmailTapped))
                }
            }
            .padding(16)
            .navigationTitle("Restore Password")
        }
        .presentationFrame(.standard)
        .applyViewBackground()

    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: "Forget Password?",
                     subtitle: "Type your email address and we will send you a link to reset your password.")
            AppTextField(type: .email, text: $viewModel.email)
            ValidationView(validationHandler: viewModel.emailValidationHandler)
        }
    }
}
