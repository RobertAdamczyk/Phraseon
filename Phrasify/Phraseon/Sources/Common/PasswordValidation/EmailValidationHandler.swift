//
//  EmailValidationHandler.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

final class EmailValidationHandler: ValidationHandlerProtocol {

    enum ValidationError: ValidationErrorProtocol {
        case empty
        case badlyFormatted

        var localizedTitle: String {
            switch self {
            case .empty:
                return "No email address entered. Please provide an email address."
            case .badlyFormatted:
                return "The email address is incorrectly formatted. Please ensure it meets the standard email format requirements."
            }
        }
    }

    @Published private(set) var validationError: ValidationError?
    @Published var shake: Bool = false

    func resetValidation() {
        validationError = nil
        shake = false
    }

    func validate(email: String) -> Result<Void, ValidationError> {
        if email.isEmpty {
            self.validationError = .empty
            return .failure(.empty)
        }
        let atSymbols = email.filter { $0 == "@" }.count
        if atSymbols != 1 {
            self.validationError = .badlyFormatted
            return .failure(.badlyFormatted)
        }

        let parts = email.split(separator: "@", maxSplits: 1, omittingEmptySubsequences: false)
        let localPart = parts[0]
        let domainPart = parts[1]

        if localPart.count < 3 {
            self.validationError = .badlyFormatted
            return .failure(.badlyFormatted)
        }

        let domainParts = domainPart.split(separator: ".", omittingEmptySubsequences: false)
        if domainParts.count < 2 {
            self.validationError = .badlyFormatted
            return .failure(.badlyFormatted)
        }

        for part in domainParts {
            if part.isEmpty {
                self.validationError = .badlyFormatted
                return .failure(.badlyFormatted)
            }
        }

        if let topDomain = domainParts.last, topDomain.count >= 2 {
            return .success(Void())
        } else {
            self.validationError = .badlyFormatted
            return .failure(.badlyFormatted)
        }
    }
}

