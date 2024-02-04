//
//  SelectBaseLanguageView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

struct SelectBaseLanguageView: View {

    @ObservedObject var viewModel: SelectBaseLanguageViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    AppTitle(subtitle: "Set the base language for your project from the list of available languages. The base language serves as the primary reference for all translations.")
                    VStack(spacing: 12) {
                        ForEach(viewModel.languages, id: \.self) { language in
                            Button(action: {
                                viewModel.onLanguageTapped(language)
                            }, label: {
                                makeLanguageRow(for: language)
                            })
                        }
                    }
                }
                .padding(16)
            }
            AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onSaveButtonTapped))
                .disabled(viewModel.shouldButtonDisabled)
                .padding(16)
        }
        .navigationTitle("Choose base language")
        .applyViewBackground()
    }

    private func makeLanguageRow(for language: Language) -> some View {
        HStack(spacing: 16) {
            SelectableCircle(isSelected: viewModel.selectedBaseLanguage == language)
            HStack(spacing: 8) {
                Image(language.rawValue)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(2)
                    .background {
                        Circle()
                            .fill(appColor(.white))
                    }
                Text(language.localizedTitle)
                    .apply(.medium, size: .L, color: viewModel.selectedBaseLanguage == language ? .white : .lightGray)
            }
            Spacer()
        }
        .padding(16)
        .applyCellBackground()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .fill(viewModel.selectedBaseLanguage == language ? appColor(.lightGray) : .clear)
        }
    }
}
