//
//  SelectBaseLanguageView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI
import Model

struct SelectBaseLanguageView: View {

    @ObservedObject var viewModel: SelectBaseLanguageViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                AppTitle(subtitle: "Set the base language for your project from the list of available languages. The base language serves as the primary reference for all translations.")
                VStack(spacing: viewModel.isInNavigationStack ? 24 : 12) {
                    ForEach(viewModel.utility.languages, id: \.self) { language in
                        Button(action: {
                            viewModel.onLanguageTapped(language)
                        }, label: {
                            makeLanguageRow(for: language)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(viewModel.isInNavigationStack ? 32 : 16)
            .padding(.bottom, ActionBottomBarConstants.height)
        }
        .makeActionBottomBar(padding: viewModel.isInNavigationStack ? .large : .small, content: {
            Spacer()
            if !viewModel.isInNavigationStack {
                AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCloseButtonTapped))
            }
            AppButton(style: .fill(viewModel.utility.buttonText, .lightBlue), action: .async(viewModel.onSaveButtonTapped))
                .disabled(viewModel.utility.shouldButtonDisabled)
        })
        .navigationTitle("Base language")
        .applyViewBackground()
        .presentationFrame(.standard)
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

