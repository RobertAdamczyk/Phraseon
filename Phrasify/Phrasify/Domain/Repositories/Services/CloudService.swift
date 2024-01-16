//
//  CloudService.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import Foundation

protocol CloudService {

    associatedtype Model: Codable

    var functionName: String { get }
    var requestModel: Model { get }
    func getParameters() throws -> [String: Any]
}
