//
//  SelectLanguageView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

struct SelectLanguageView: View {

    @ObservedObject var viewModel: SelectLanguageViewModel

    @Namespace private var animation

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView
                .zIndex(4)
            horizontalScrollView
                .zIndex(1)
            verticalScrollView
                .zIndex(0)
            buttonView
                .zIndex(3)
        }
        .padding(16)
        .navigationTitle("Languages")
    }

    @ViewBuilder
    private var titleView: some View {
        AppTitle(subtitle: viewModel.subtitle)
        .padding(.bottom, 16)
        .background(appColor(.black))
    }

    @ViewBuilder
    private var horizontalScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if viewModel.shouldShowPlaceholder {
                    ZStack(alignment: .leading) {
                        Text("Select language")
                            .apply(.regular, size: .M, color: .darkGray)
                        makeSelectedLanguageView(title: "PLACEHOLDER").opacity(0)
                    }
                }
                ForEach(viewModel.selectedLanguages, id: \.self) { language in
                    makeSelectedLanguageView(title: language.localizedTitle)
                        .matchedGeometryEffect(id: language, in: animation)
                        .onTapGesture {
                            viewModel.onLanguageDeleteTapped(language)
                        }
                }
            }
        }
        .scrollClipDisabled(true)
        .padding(.vertical, 16)
        .background(appColor(.black))
    }

    @ViewBuilder
    private var verticalScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TagLayout(alignment: .center) {
                ForEach(viewModel.availableLanguages, id: \.self) { language in
                    makeLanguageView(title: language.localizedTitle)
                        .matchedGeometryEffect(id: language, in: animation)
                        .onTapGesture {
                            viewModel.onLanguageTapped(language)
                        }
                 }
            }
            .padding(16)
        }
        .scrollClipDisabled(true)
        .background(appColor(.darkGray))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var buttonView: some View {
        AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .main(viewModel.onPrimaryButtonTapped),
                  disabled: viewModel.shouldPrimaryButtonDisabled)
        .padding(.top, 16)
    }

    @ViewBuilder
    private func makeSelectedLanguageView(title: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
            Image(systemName: "checkmark")
        }
        .apply(.regular, size: .M, color: .black)
        .padding(8)
        .background {
            Capsule()
                .fill(appColor(.paleOrange).gradient)
        }
    }

    @ViewBuilder
    private func makeLanguageView(title: String) -> some View {
        HStack(spacing: 8) {
            Text(title)
            Image(systemName: "plus")
        }
        .apply(.regular, size: .M, color: .black)
        .padding(8)
        .background {
            Capsule()
                .fill(appColor(.lightBlue).gradient)
        }
    }
}

#Preview {
    SelectLanguageView(viewModel: .init(coordinator: MockCoordinator(), context: .createProject(name: "NAME")))
}

