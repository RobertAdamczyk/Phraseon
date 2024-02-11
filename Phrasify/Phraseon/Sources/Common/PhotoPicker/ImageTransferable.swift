//
//  ImageTransferable.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 02.01.24.
//

import SwiftUI
import PhotosUI

struct ImageTransferable: Transferable {
    let image: Image
    let uiImage: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw AppError.imageNil
            }
            let image = Image(uiImage: uiImage)
            return ImageTransferable(image: image, uiImage: uiImage)
        }
    }
}
