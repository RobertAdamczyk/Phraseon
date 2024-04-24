//
//  ImageTransferable.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 24.04.24.
//

import Model
import PhotosUI
import SwiftUI

struct ImageTransferable: Transferable {
    let image: Image
    let nsImage: NSImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let nsImage = NSImage(data: data) else {
                throw AppError.imageNil
            }
            let image = Image(nsImage: nsImage)
            return ImageTransferable(image: image, nsImage: nsImage)
        }
    }
}
