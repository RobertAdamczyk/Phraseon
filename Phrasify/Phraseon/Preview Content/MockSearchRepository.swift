//
//  PreviewSearchRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import Model

final class PreviewSearchRepository: SearchRepository {

    func searchKeys(in project: Project, with text: String, completion: @escaping (Result<[AlgoliaKey], Error>) -> Void) {
        // empty
    }
}
