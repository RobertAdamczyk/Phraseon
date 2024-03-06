//
//  StorageRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 02.01.24.
//

import FirebaseStorage
import UIKit
import Model

public protocol StorageRepository {

    func uploadImage(path: StorageRepositoryImpl.StoragePath, image: UIImage) async throws -> StorageMetadata

    func downloadURL(for path: StorageRepositoryImpl.StoragePath) async throws -> URL
}

public final class StorageRepositoryImpl: StorageRepository {

    public init() { }

    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()

    public enum StoragePath {
        case userImage(fileName: String)

        var rawValue: String {
            switch self {
            case .userImage(let fileName):
                return "user/\(fileName)/image.jpg"
            }
        }
    }

    public func uploadImage(path: StoragePath, image: UIImage) async throws -> StorageMetadata {
        guard let data = image.jpegData(compressionQuality: 0.1) else { throw AppError.imageCompressionNil }

        // Create a reference to the file you want to upload
        let ref = storageRef.child(path.rawValue)

        return try await ref.putDataAsync(data)
    }

    public func downloadURL(for path: StoragePath) async throws -> URL {
        let ref = storageRef.child(path.rawValue)
        return try await ref.downloadURL()
    }
}
