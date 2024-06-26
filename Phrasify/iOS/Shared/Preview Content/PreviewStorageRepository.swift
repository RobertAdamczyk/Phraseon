//
//  PreviewStorageRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import FirebaseStorage
import Domain

final class PreviewStorageRepository: StorageRepository {

    func uploadImage(path: StorageRepositoryImpl.StoragePath, imageData: Data) async throws -> FirebaseStorage.StorageMetadata {
        return .init()
    }
    
    func downloadURL(for path: StorageRepositoryImpl.StoragePath) async throws -> URL {
        .userDirectory
    }
}
