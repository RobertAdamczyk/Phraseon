//
//  ForgetPasswordView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct ForgetPasswordView: View {

    @ObservedObject var viewModel: ForgetPasswordViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: "Forget Password?",
                     subtitle: "Type your email address and we will send you a link to reset your password.")
            AppTextField(type: .email, text: $viewModel.email)
            AppButton(style: .fill("Send Email", .lightBlue), action: .async(viewModel.onSendEmailTapped))
            Spacer()
        }
        .padding(16)
        .background(appColor(.black))
    }
}

#Preview {
    ForgetPasswordView(viewModel: .init(coordinator: MockCoordinator()))
}

