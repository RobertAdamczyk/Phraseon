//
//  CreateKeyView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 10.04.24.
//

import SwiftUI
import Model

struct CreateKeyView: View {

    @ObservedObject var viewModel: CreateKeyViewModel

    @FocusState private var focusedTextField: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 64) {
                    VStack(alignment: .leading, spacing: 32) {
                        AppTitle(subtitle: "Enter the phrase identifier – remember, this must be unique.")
                        AppTextField(type: .keyId, text: $viewModel.keyId)
                            .focused($focusedTextField)
                    }
                    VStack(alignment: .leading, spacing: 32) {
                        AppTitle(subtitle: viewModel.subtitle)
                        AppTextField(type: .keyContent, text: $viewModel.translation)
                    }
                }
                .padding(32)
            }
            AppButton(style: .fill("Continue", .lightBlue), action: .async(viewModel.onContinueButtonTapped))
                .disabled(viewModel.utility.shouldDisablePrimaryButton)
                .padding(32)
        }
        .onAppear(perform: makeTextFieldFocused)
        .navigationTitle("Add phrase")
        .applyViewBackground()
    }

    private func makeTextFieldFocused() {
        focusedTextField = true
    }
}


