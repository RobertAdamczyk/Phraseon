//
//  EnterContentKeyView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

struct EnterContentKeyView: View {

    @ObservedObject var viewModel: EnterContentKeyViewModel

    @FocusState private var focusedTextField: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: viewModel.subtitle)
                    VStack(alignment: .leading, spacing: 16) {
                        AppTextField(type: .keyContent, text: $viewModel.translation)
                    }
                }
                .padding(16)
            }
            AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .padding(16)
        }
        .onAppear(perform: makeTextFieldFocused)
        .navigationTitle("Content")
        .applyViewBackground()
    }

    private func makeTextFieldFocused() {
        focusedTextField = true
    }
}
