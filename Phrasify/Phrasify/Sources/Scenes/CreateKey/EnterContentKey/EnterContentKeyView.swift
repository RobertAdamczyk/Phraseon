//
//  EnterContentKeyView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

struct EnterContentKeyView: View {

    @ObservedObject var viewModel: EnterContentKeyViewModel

    @FocusState private var focusedTextField: Bool

    private var subtitle: String {
        "Enter the content of the phrase - remember, that the base language is \(viewModel.project.baseLanguage.localizedTitle)."
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: subtitle)
                    AppTextField(type: .translation, text: $viewModel.translation)
                        .focused($focusedTextField)
                }
                .padding([.horizontal, .top], 16)
            }
            AppButton(style: .fill("Create phrase", .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .padding(16)
        }
        .onAppear(perform: makeTextFieldFocused)
        .navigationTitle("Enter content")
    }

    private func makeTextFieldFocused() {
        focusedTextField = true
    }
}
