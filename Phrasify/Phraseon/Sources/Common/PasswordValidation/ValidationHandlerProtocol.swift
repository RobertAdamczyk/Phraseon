//
//  ValidationHandlerProtocol.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import Foundation

protocol ValidationHandlerProtocol: ObservableObject {

    associatedtype ValidationError: ValidationErrorProtocol

    var validationError: ValidationError? { get }
    var shake: Bool { get set }
}
