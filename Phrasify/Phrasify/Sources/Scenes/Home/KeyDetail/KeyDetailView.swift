//
//  KeyDetailView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

struct KeyDetailView: View {

    @ObservedObject var viewModel: KeyDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                ForEach(viewModel.project.languages.reversed(), id: \.self) { language in
                    if let translation = viewModel.key.translation[language.rawValue] {
                        makeLanguageRow(for: language, translation: translation)
                    } else {
                        makeLanguageRow(for: language, translation: nil)
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(viewModel.key.id ?? "Phrase Detail")
    }

    private func makeLanguageRow(for language: Language, translation: String?) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            LanguageView(language: language)
            VStack(alignment: .trailing, spacing: 8) {
                Text(translation ?? "No translation into the language.")
                    .apply(.regular, size: .S, color: .white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 16) {
                    editButton
                    copyButton
                }
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(appColor(.darkGray))
            }
        }
    }

    private var editButton: some View {
        Button {
            print("XD")
        } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: 22, height: 22)
                .apply(.medium, size: .M, color: .paleOrange)
        }
    }

    private var copyButton: some View {
        Button {
            print("XD")
        } label: {
            Image(systemName: "doc.on.doc")
                .resizable()
                .frame(width: 18, height: 22)
                .apply(.medium, size: .M, color: .paleOrange)
        }
    }
}

#Preview {
    KeyDetailView(viewModel: .init(coordinator: MockCoordinator(), 
                                   key: .init(translation: ["EN": "dasdasdasdadasd"],
                                              createdAt: .now, 
                                              lastUpdatedAt: .now,
                                              status: .approved),
                                   project: .init(name: "",
                                                  technologies: [],
                                                  languages: [.english, .arabic],
                                                  baseLanguage: .english,
                                                  members: [],
                                                  owner: "adasda")))
    .preferredColorScheme(.dark)
}
