//
//  CloudService.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation
import Model

protocol CloudService {

    associatedtype Model: Codable

    var functionName: String { get }
    var requestModel: Model { get }
    func getParameters() throws -> [String: Any]
}

extension CloudService {

    func getParameters() throws -> [String: Any] {
        let jsonData = try JSONEncoder().encode(requestModel)
        if let parameters = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] {
            return parameters
        }
        throw AppError.encodingError
    }
}
