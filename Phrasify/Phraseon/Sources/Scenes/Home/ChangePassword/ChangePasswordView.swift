//
//  ChangePasswordView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 01.01.24.
//

import SwiftUI

struct ChangePasswordView: View {

    @ObservedObject var viewModel: ChangePasswordViewModel

    @FocusState private var focusedTextField: AppTextField.TType?

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                switch viewModel.state {
                case .unavailable: unavailableContent
                default: content
                }
            }
            AppButton(style: .fill(viewModel.primaryButtonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .padding(16)
        }
        .navigationTitle("Change password")
        .onAppear(perform: setCurrentPasswordFocus)
        .applyViewBackground()
    }

    private var content: some View {
        VStack(spacing: 16) {
            AppTextField(type: .currentPassword, text: $viewModel.currentPassword)
                .focused($focusedTextField, equals: .currentPassword)
                .disabled(viewModel.state == .newPassword)
            ZStack {
                if viewModel.shouldShowNewPassword {
                    AppTextField(type: .newPassword, text: $viewModel.newPassword)
                        .focused($focusedTextField, equals: .newPassword)
                        .transition(.move(edge: .top))
                        .onAppear(perform: setNewPasswordFocus)
                }
            }
            .opacity(viewModel.shouldShowNewPassword ? 1 : 0)
            ZStack {
                if viewModel.shouldShowConfirmNewPassword {
                    AppTextField(type: .confirmPassword, text: $viewModel.confirmNewPassword)
                        .focused($focusedTextField, equals: .confirmPassword)
                        .transition(.move(edge: .top))
                        .onAppear(perform: setConfirmNewPasswordFocus)
                }
            }
            .opacity(viewModel.shouldShowConfirmNewPassword ? 1 : 0)
            ValidationView(validationHandler: viewModel.passwordValidationHandler)
        }
        .animation(.easeInOut, value: viewModel.state)
        .padding(16)
    }

    private var unavailableContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Unavailable for Google Accounts")
                .apply(.bold, size: .L, color: .white)
            Text("Notice: As you're logged in using your Google account, the password for this app cannot be changed here. Your app login is linked to your Google account, and any password changes must be made through your Google account settings. Please visit Google's account management to update your password. We appreciate your understanding and are here to assist with any other account inquiries you may have.")
                .apply(.regular, size: .S, color: .white)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
    }

    private func setCurrentPasswordFocus() {
        focusedTextField = .currentPassword
    }

    private func setNewPasswordFocus() {
        focusedTextField = .newPassword
    }

    private func setConfirmNewPasswordFocus() {
        focusedTextField = .confirmPassword
    }
}

