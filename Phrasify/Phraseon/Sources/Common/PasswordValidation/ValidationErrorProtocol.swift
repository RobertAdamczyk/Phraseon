//
//  ValidationErrorProtocol.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.01.24.
//

import Foundation

protocol ValidationErrorProtocol: Error {

    var localizedTitle: String { get }
}
