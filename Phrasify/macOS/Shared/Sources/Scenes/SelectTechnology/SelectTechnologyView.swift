//
//  SelectTechnologyView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

struct SelectTechnologyView: View {

    @ObservedObject var viewModel: SelectTechnologyViewModel

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
        .navigationTitle("Technologies")
        .applyViewBackground()
        .presentationMinimalFrame()
    }

    @ViewBuilder
    private var titleView: some View {
        AppTitle(subtitle: viewModel.utility.subtitle)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var horizontalScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if viewModel.utility.shouldShowPlaceholder {
                    ZStack(alignment: .leading) {
                        Text("Select technology")
                            .apply(.regular, size: .M, color: .darkGray)
                        makeSelectedTechnologyView(title: "PLACEHOLDER").opacity(0)
                    }
                }
                ForEach(viewModel.selectedTechnologies, id: \.self) { technology in
                    makeSelectedTechnologyView(title: technology.title)
                        .matchedGeometryEffect(id: technology, in: animation)
                        .onTapGesture {
                            viewModel.onTechnologyDeleteTapped(technology)
                        }
                }
            }
        }
        .scrollClipDisabled(true)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private var verticalScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            TagLayout(alignment: .center) {
                ForEach(viewModel.utility.availableTechnologies, id: \.self) { technology in
                    makeTechnologyView(title: technology.title)
                        .matchedGeometryEffect(id: technology, in: animation)
                        .onTapGesture {
                            viewModel.onTechnologyTapped(technology)
                        }
                 }
            }
            .padding(16)
        }
        .scrollClipDisabled(true)
        .applyCellBackground()
    }

    @ViewBuilder
    private var buttonView: some View {
        HStack(spacing: 16) {
            Spacer()
            AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCloseButtonTapped))
            AppButton(style: .fill(viewModel.utility.buttonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .disabled(viewModel.utility.shouldPrimaryButtonDisabled)
        }
        .padding(.top, 16)
    }

    @ViewBuilder
    private func makeSelectedTechnologyView(title: String) -> some View {
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
    private func makeTechnologyView(title: String) -> some View {
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
