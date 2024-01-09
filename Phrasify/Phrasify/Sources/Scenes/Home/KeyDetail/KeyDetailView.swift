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

        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    ForEach(viewModel.project.languages.reversed(), id: \.self) { language in
                        if let translation = viewModel.key.translation[language.rawValue] {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 16) {
                                    Image(language.rawValue)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(2)
                                        .background {
                                            Circle()
                                                .fill(appColor(.white))
                                        }
                                    Text(language.localizedTitle + (language == viewModel.project.baseLanguage ? " (Base)" : ""))
                                        .apply(.medium, size: .L, color: .lightGray)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(appColor(.darkGray))
                                }
                                Text(translation)
                                    .apply(.regular, size: .S, color: .white)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(appColor(.darkGray))
                                    }
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 16) {
                                    Image(language.rawValue)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .padding(2)
                                        .background {
                                            Circle()
                                                .fill(appColor(.white))
                                        }
                                    Text(language.localizedTitle)
                                        .apply(.medium, size: .L, color: .lightGray)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundStyle(appColor(.darkGray))
                                }
                                Text("No translation into the language.")
                                    .apply(.regular, size: .S, color: .white)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 16)
                                            .foregroundStyle(appColor(.darkGray))
                                    }
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle(viewModel.key.id ?? "Phrase Detail")
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
