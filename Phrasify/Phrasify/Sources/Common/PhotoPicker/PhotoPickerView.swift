//
//  PhotoPickerView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView<T1: View, T2: View>: View {

    @StateObject var photoHandler: PhotoPickerHandler

    let width: CGFloat
    let height: CGFloat

    @ViewBuilder var imageLabel: (Image) -> T1
    @ViewBuilder var emptyLabel: () -> T2

    init(width: CGFloat, height: CGFloat, completion: ((UIImage) async throws -> Void)? = nil,
         @ViewBuilder imageLabel: @escaping (Image) -> T1,
         @ViewBuilder emptyLabel: @escaping () -> T2) {
        self._photoHandler = .init(wrappedValue: .init(completion: completion))
        self.width = width
        self.height = height
        self.imageLabel = imageLabel
        self.emptyLabel = emptyLabel
    }

    var body: some View {
        ZStack {
            switch photoHandler.imageState {
            case .success(let image):
                imageLabel(image)
            case .loading(let progress):
                ProgressView(progress)
            case .empty:
                emptyLabel()
            }
        }
        .frame(width: width, height: height)
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
