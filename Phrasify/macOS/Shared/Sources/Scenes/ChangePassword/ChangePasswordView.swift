//
//  ChangePasswordView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI

struct ChangePasswordView: View {

    @ObservedObject var viewModel: ChangePasswordViewModel

    @FocusState private var focusedTextField: AppTextField.TType?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ZStack {
                    switch viewModel.state {
                    case .unavailable: unavailableContent
                    default: content
                    }
                }
                .padding(16)
                .padding(.bottom, ActionBottomBarConstants.height)
            }
            .makeActionBottomBar(padding: .small) {
                Spacer()
                if viewModel.shouldShowCancelButton {
                    AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelButtonTapped))
                }
                AppButton(style: .fill(viewModel.utility.primaryButtonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
            }
            .navigationTitle(viewModel.utility.navigationTitle)
        }
        .onAppear(perform: setCurrentPasswordFocus)
        .applyViewBackground()
        .presentationFrame(.standard)
    }

    private var content: some View {
        VStack(spacing: 16) {
            AppTextField(type: .currentPassword, text: $viewModel.currentPassword)
                .focused($focusedTextField, equals: .currentPassword)
                .disabled(viewModel.utility.shouldCurrentPasswordDisabled)
            ZStack {
                if viewModel.utility.shouldShowNewPassword {
                    AppTextField(type: .newPassword, text: $viewModel.newPassword)
                        .focused($focusedTextField, equals: .newPassword)
                        .transition(.move(edge: .top))
                        .onAppear(perform: setNewPasswordFocus)
                }
            }
            .opacity(viewModel.utility.shouldShowNewPassword ? 1 : 0)
            ZStack {
                if viewModel.utility.shouldShowConfirmNewPassword {
                    AppTextField(type: .confirmPassword, text: $viewModel.confirmNewPassword)
                        .focused($focusedTextField, equals: .confirmPassword)
                        .transition(.move(edge: .top))
                        .onAppear(perform: setConfirmNewPasswordFocus)
                }
            }
            .opacity(viewModel.utility.shouldShowConfirmNewPassword ? 1 : 0)
            ValidationView(validationHandler: viewModel.passwordValidationHandler)
        }
        .animation(.easeInOut, value: viewModel.state)
    }

    private var unavailableContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.utility.unavailableContentTitle)
                .apply(.bold, size: .L, color: .white)
            Text(viewModel.utility.unavailableContentMessage)
                .apply(.regular, size: .S, color: .white)
                .multilineTextAlignment(.leading)
        }
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


