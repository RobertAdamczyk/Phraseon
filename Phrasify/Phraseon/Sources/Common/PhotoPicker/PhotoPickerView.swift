//
//  PhotoPickerView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView<T1: View, T2: View, T3: View>: View {

    @StateObject var photoHandler: PhotoPickerHandler

    @ViewBuilder var imageLabel: (Image) -> T1
    @ViewBuilder var placeholderLabel: () -> T2
    @ViewBuilder var progressLabel: () -> T3

    init(completion: ((UIImage) async throws -> Void)? = nil,
         @ViewBuilder imageLabel: @escaping (Image) -> T1,
         @ViewBuilder placeholderLabel: @escaping () -> T2,
         @ViewBuilder progressLabel: @escaping () -> T3) {
        self._photoHandler = .init(wrappedValue: .init(completion: completion))
        self.imageLabel = imageLabel
        self.placeholderLabel = placeholderLabel
        self.progressLabel = progressLabel
    }

    var body: some View {
        ZStack {
            switch photoHandler.imageState {
            case .success(let image):
                imageLabel(image)
            case .loading:
                progressLabel()
            case .empty:
                placeholderLabel()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(selection: $photoHandler.imageSelection, matching: .images) {
                Image(systemName: "pencil")
                    .apply(.bold, size: .M, color: .black)
                    .padding(6)
                    .background {
                        Circle()
                            .fill(appColor(.paleOrange))
                    }
            }
        }
    }
}
