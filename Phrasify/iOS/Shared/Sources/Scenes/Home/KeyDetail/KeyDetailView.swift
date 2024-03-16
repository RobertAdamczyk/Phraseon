//
//  KeyDetailView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI
import Model

struct KeyDetailView: View {

    @ObservedObject var viewModel: KeyDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 32) {
                makeIdentifierRow()
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
        .navigationTitle("Phrase")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.member?.hasPermissionToDeleteKey == true {
                    Button(action: viewModel.onDeleteTapped, label: {
                        Image(systemName: "trash")
                            .apply(.bold, size: .L, color: .paleOrange)
                    })
                }
            }
        }
        .applyViewBackground()
    }

    private func makeIdentifierRow() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "grid")
                    .foregroundStyle(appColor(.white))
                Text("Identifier")
                    .apply(.medium, size: .L, color: .lightGray)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .applyCellBackground()
            VStack(alignment: .trailing, spacing: 12) {
                if let keyId = viewModel.key.id {
                    Text(keyId)
                        .apply(.regular, size: .S, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    makeCopyButton(for: keyId)
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .applyCellBackground()
            AppDivider(color: appColor(.lightGray))
                .padding(.top, 16)
        }
    }

    private func makeLanguageRow(for language: Language, translation: String?) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            LanguageView(language: language, isBaseLanguage: viewModel.project.baseLanguage == language)
            VStack(alignment: .trailing, spacing: 12) {
                Text(translation ?? "No translation into the language.")
                    .apply(.regular, size: .S, color: .white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 16) {

                    if let keyStatus = viewModel.key.status[language.rawValue], viewModel.shouldShowApproveButton {
                        if keyStatus == .review && viewModel.member?.hasPermissionToApproveKey == true {
                            ApproveButton(language: language, action: viewModel.onApproveTapped)
                        } else {
                            Text(keyStatus.localizedTitle)
                                .apply(.regular, size: .S, color: .lightGray)
                        }
                    }

                    if viewModel.member?.hasPermissionToEditContentKey == true {
                        makeEditButton(for: language)
                    }
                    if let translation {
                        makeCopyButton(for: translation)
                    }
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .applyCellBackground()
        }
    }

    private func makeEditButton(for language: Language) -> some View {
        Button {
            viewModel.onEditTranslationTapped(language: language)
        } label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .frame(width: 22, height: 22)
                .apply(.medium, size: .M, color: .paleOrange)
        }
    }

    private func makeCopyButton(for text: String) -> some View {
        Button {
            viewModel.onCopyTapped(text)
        } label: {
            Image(systemName: "doc.on.doc")
                .resizable()
                .frame(width: 18, height: 22)
                .apply(.medium, size: .M, color: .paleOrange)
        }
    }
}

#if DEBUG
#Preview {
    KeyDetailView(viewModel: .init(coordinator: PreviewCoordinator(), 
                                   key: .init(translation: ["EN": "dasdasdasdadasd"],
                                              createdAt: .now,
                                              lastUpdatedAt: .now,
                                              status: ["EN": KeyStatus.approved]),
                                   project: .init(name: "",
                                                  technologies: [],
                                                  languages: [.english, .polish],
                                                  baseLanguage: .english,
                                                  members: [],
                                                  owner: "adasda",
                                                  securedAlgoliaApiKey: "",
                                                  createdAt: .now,
                                                  algoliaIndexName: ""),
                                   projectMemberUseCase: .init(firestoreRepository: PreviewFirestoreRepository(),
                                                               authenticationRepository: PreviewAuthenticationRepository(),
                                                               project: .init(name: "",
                                                                              technologies: [],
                                                                              languages: [],
                                                                              baseLanguage: .english, 
                                                                              members: [],
                                                                              owner: "",
                                                                              securedAlgoliaApiKey: "",
                                                                              createdAt: .now,
                                                                              algoliaIndexName: ""))))
    .preferredColorScheme(.dark)
}
#endif
