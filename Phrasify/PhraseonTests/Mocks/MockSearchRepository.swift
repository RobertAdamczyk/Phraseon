//
//  MockSearchRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import Foundation
@testable import Phraseon_InHouse
@testable import Model
@testable import Domain

final class MockSearchRepository: SearchRepository {

    var searchText: String? = nil
    var project: Project? = nil

    enum MockSearch {
        case found([AlgoliaKey])
        case notFound
        case error
    }

    var mockSearch: MockSearch? = nil

    func searchKeys(in project: Project,
                    with text: String,
                    completion: @escaping (Result<[AlgoliaKey], Error>) -> Void) {
        self.searchText = text
        self.project = project

        switch mockSearch {
        case .found(let keys):
            completion(.success(keys))
        case .notFound:
            completion(.success([]))
        case .error:
            completion(.failure(AppError.decodingError))
        default:
            fatalError("Need set emptySearch flag")
        }
    }
}
