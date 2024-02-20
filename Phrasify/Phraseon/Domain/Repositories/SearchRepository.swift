//
//  SearchRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 06.02.24.
//

import Foundation
import AlgoliaSearchClient

protocol SearchRepository {

    func searchKeys(in project: Project, with text: String, completion: @escaping (Result<[AlgoliaKey], Error>) -> Void)
}

final class SearchRepositoryImpl: SearchRepository {

    func searchKeys(in project: Project, with text: String, completion: @escaping (Result<[AlgoliaKey], Error>) -> Void) {
        let client = getClient(for: project.securedAlgoliaApiKey)
        let index = client.index(withName: .init(rawValue: project.algoliaIndexName))
        let query = Query(text)
        index.search(query: query) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                do {
                    let keys = try response.hits.compactMap { hit -> AlgoliaKey? in
                        // Convert hit object to Data
                        let data = try JSONSerialization.data(withJSONObject: hit.object.object() as Any, options: [])
                        // Decode the data into an AlgoliaKey
                        return try decoder.decode(AlgoliaKey.self, from: data)
                    }
                    completion(.success(keys))
                } catch {
                    completion(.failure(AppError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getClient(for securedApiKey: String) -> SearchClient {
        .init(appID: .init(rawValue: Secrets.algoliaAppId), apiKey: .init(rawValue: securedApiKey))
    }
}
