//
//  CreateKeyView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

struct CreateKeyView: View {

    @StateObject private var viewModel: CreateKeyViewModel

    @FocusState private var focusedTextField: Bool

    init(coordinator: CreateKeyViewModel.CreateKeyCoordinator, project: Project) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator, project: project))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: "Enter the phrase identifier – remember, this must be unique.")
                    AppTextField(type: .keyId, text: $viewModel.keyId)
                        .focused($focusedTextField)
                }
                .padding([.horizontal, .top], 16)
            }
            AppButton(style: .fill("Continue", .lightBlue), action: .main(viewModel.onContinueButtonTapped), 
                      disabled: viewModel.shouldDisablePrimaryButton)
                .padding(16)
        }
        .onAppear(perform: makeTextFieldFocused)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark")
                })
            }
        }
        .navigationTitle("Add phrase")
    }

    private func makeTextFieldFocused() {
        focusedTextField = true
    }
}

