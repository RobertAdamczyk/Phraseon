//
//  PreviewStorageRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import FirebaseStorage
import UIKit

final class PreviewStorageRepository: StorageRepository {

    func uploadImage(path: StorageRepositoryImpl.StoragePath, image: UIImage) async throws -> FirebaseStorage.StorageMetadata {
        return .init()
    }
    
    func downloadURL(for path: StorageRepositoryImpl.StoragePath) async throws -> URL {
        .userDirectory
    }
}
