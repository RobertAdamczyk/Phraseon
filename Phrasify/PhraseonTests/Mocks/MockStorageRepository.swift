//
//  MockStorageRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import Foundation
import Model
import Domain
import FirebaseStorage

final class MockStorageRepository: StorageRepository {

    var calledUploadImageCalled: Bool?
    var mockDownloadURL: URL?

    func uploadImage(path: StorageRepositoryImpl.StoragePath, imageData: Data) async throws -> StorageMetadata {
        self.calledUploadImageCalled = true
        return .init()
    }

    func downloadURL(for path: StorageRepositoryImpl.StoragePath) async throws -> URL {
        return mockDownloadURL ?? .applicationDirectory
    }
}
