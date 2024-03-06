//
//  AppError.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.12.23.
//

import Foundation

public enum AppError: Error, LocalizedError {

    case idTokenNil
    case idClientNil
    case googleAuthNil
    case viewControllerNil
    case imageNil
    case decodingError
    case encodingError
    case notFound
    case alreadyMember
    case purchaseFailedVerification
    case purchasePending
    case purchaseCancelled
    case purchaseGeneralError
}
