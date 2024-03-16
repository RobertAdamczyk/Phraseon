//
//  PhotoPickerHandler.swift
//  Phraseon
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

    var completion: ((UIImage) async throws -> Void)?

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

    init(completion: ((UIImage) async throws -> Void)? = nil) {
        self.completion = completion
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
                    Task { [weak self] in
                        do {
                            try await self?.completion?(profileImage.uiImage)
                            self?.imageState = .success(profileImage.image)
                        } catch {
                            ToastView.showGeneralError()
                            self?.imageState = .empty
                        }
                    }
                case .success(nil):
                    self.imageState = .empty
                case .failure:
                    ToastView.showGeneralError()
                    self.imageState = .empty
                }
            }
        }
    }
}
