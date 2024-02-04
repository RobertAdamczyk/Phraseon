//
//  CloudResponse.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 19.01.24.
//

import Foundation

protocol CloudResponse: Decodable {
    associatedtype Model: Decodable

    static func decode(from data: Any) throws -> Model
}

extension CloudResponse {
    static func decode(from data: Any) throws -> Model {
        guard let jsonData = data as? [String: Any] else {
            throw AppError.decodingError
        }

        let data = try JSONSerialization.data(withJSONObject: jsonData)
        let responseModel = try JSONDecoder().decode(Model.self, from: data)
        return responseModel
    }
}
