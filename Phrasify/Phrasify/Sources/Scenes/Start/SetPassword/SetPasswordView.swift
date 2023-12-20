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
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: "Set your password")
            AppTextField(type: .password, text: $viewModel.password)
            AppTextField(type: .confirmPassword, text: $viewModel.confirmPassword)
            AppButton(style: .fill("Create an Account", .lightBlue), action: .async(viewModel.onCreateAccountTapped))
            Spacer()
        }
        .padding(16)
        .background(appColor(.black))
    }
}

#Preview {
    SetPasswordView(viewModel: .init(email: "", coordinator: MockCoordinator()))
}
