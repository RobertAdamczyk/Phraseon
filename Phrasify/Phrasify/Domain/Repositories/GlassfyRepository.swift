//
//  GlassfyRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import Foundation
import Glassfy

final class GlassfyRepository {

    func getOffers() async throws -> [Glassfy.Sku] {
        let response = try await Glassfy.offerings()
        if let offers = response["PremiumAccess"] {
            return offers.skus
        }
        return []
    }

    func purchase(product: Glassfy.Sku) async throws {
        let response = try await Glassfy.purchase(sku: product)
        if let permission = response.permissions["PremiumAccess"], permission.isValid {
            return
        } else {
            throw AppError.notFound
        }
    }

    func restorePurchase() async throws {
        try await Glassfy.restorePurchases()
    }

    func checkPermission() async throws -> Glassfy.Permissions {
        return try await Glassfy.permissions()
    }
}
