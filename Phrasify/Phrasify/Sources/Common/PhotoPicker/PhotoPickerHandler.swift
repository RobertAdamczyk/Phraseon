//
//  PhotoPickerHandler.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import SwiftUI
import PhotosUI

final class PhotoPickerHandler: ObservableObject {

    enum ImageState {
        case success(Image)
        case loading(Progress)
        case empty
    }

    @Published var imageState: ImageState = .empty

    var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageTransferable.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    ToastView.showError(message: error.localizedDescription)
                    self.imageState = .empty
                }
            }
        }
    }
}
