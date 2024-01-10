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
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(subtitle: subtitle)
                    VStack(alignment: .leading, spacing: 16) {
                        LanguageView(language: viewModel.project.baseLanguage)
                        TextField("", text: $viewModel.translation,
                                  prompt: Text(verbatim: "Content").foregroundStyle(appColor(.lightGray)), axis: .vertical)
                        .apply(.regular, size: .S, color: .white)
                        .focused($focusedTextField)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(appColor(.darkGray))
                        }
                    }
                }
                .padding(16)
            }
            AppButton(style: .fill("Create phrase", .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .padding(16)
        }
        .onAppear(perform: makeTextFieldFocused)
        .navigationTitle("Content")
    }

    private func makeTextFieldFocused() {
        focusedTextField = true
    }
}
