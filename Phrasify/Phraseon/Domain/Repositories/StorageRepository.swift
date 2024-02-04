//
//  StorageRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import FirebaseStorage
import UIKit

final class StorageRepository {

    lazy var storage = Storage.storage()
    lazy var storageRef = storage.reference()

    enum StoragePath {
        case userImage(fileName: String)

        var rawValue: String {
            switch self {
            case .userImage(let fileName):
                return "user/\(fileName)/image.jpg"
            }
        }
    }

    func uploadImage(path: StoragePath, image: UIImage) async throws -> StorageMetadata {
        guard let data = image.jpegData(compressionQuality: 0.1) else { throw AppError.imageCompressionNil }

        // Create a reference to the file you want to upload
        let ref = storageRef.child(path.rawValue)

        return try await ref.putDataAsync(data)
    }

    func downloadURL(for path: StoragePath) async throws -> URL {
        let ref = storageRef.child(path.rawValue)
        return try await ref.downloadURL()
    }
}
