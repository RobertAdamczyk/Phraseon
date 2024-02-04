//
//  AppError.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.12.23.
//

import Foundation

enum AppError: Error, LocalizedError {

    case idTokenNil
    case idClientNil
    case googleAuthNil
    case viewControllerNil
    case imageNil
    case imageCompressionNil
    case decodingError
    case encodingError
    case notFound
    case alreadyMember
    case purchaseFailedVerification
    case purchasePending
    case purchaseCancelled
    case purchaseGeneralError
}
