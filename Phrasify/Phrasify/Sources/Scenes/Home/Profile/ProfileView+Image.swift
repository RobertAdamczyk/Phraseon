//
//  ProfileView+Image.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 03.01.24.
//

import SwiftUI
import CachedAsyncImage

extension ProfileView {

    struct ImageView: View {

        @ObservedObject var viewModel: ProfileViewModel

        private let height: CGFloat = 80
        private let width: CGFloat = 80
        private let padding: CGFloat = 4

        var body: some View {
            PhotoPickerView(completion: viewModel.uploadProfileImage,
                            imageLabel: makeImage,
                            placeholderLabel: makePlaceholderLabel,
                            progressLabel: makeProgressView)
        }

        @ViewBuilder
        private func makePlaceholderLabel() -> some View {
            if let urlString = viewModel.user?.photoUrl, let url = URL(string: urlString) {
                CachedAsyncImage(url: url, content: makeImage, placeholder: makeProgressView)
            } else {
                makeImage(for: Image(systemName: "person.crop.circle.fill"))
            }
        }

        private func makeImage(for image: Image) -> some View {
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(.circle)
                .padding(padding)
                .background {
                    Circle().fill(appColor(.white))
                }
        }

        private func makeProgressView() -> some View {
            ProgressView()
                .frame(width: width + 2 * padding, height: height + 2 * padding)
        }
    }
}