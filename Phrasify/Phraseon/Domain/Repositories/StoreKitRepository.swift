//
//  StoreKitRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 24.01.24.
//

import Foundation
import StoreKit

final class StoreKitRepository {

    private var updateListenerTask: Task<Void, Error>? = nil

    init() {
        updateListenerTask = listenForTransactions()
    }

    func getProducts() async throws -> [Product] {
        let storeProducts = try await StoreKit.Product.products(for: [SubscriptionPlan.individual.id, SubscriptionPlan.team.id])
        return storeProducts
    }

    func purchase(_ product: Product, with options: Set<Product.PurchaseOption> = []) async throws -> Transaction? {
        let result = try await product.purchase(options: options)

        switch result {
        case .success(let verificationResult):
            // Check whether the transaction is verified. If it isn't,
            // this function rethrows the verification error.
            let transaction = try checkVerified(verificationResult)
            // Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled:
            throw AppError.purchaseCancelled
        case .pending:
            throw AppError.purchasePending
        @unknown default:
            throw AppError.purchaseGeneralError
        }
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a transaction that fails verification.
                    print("Transaction failed verification")
                }
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw AppError.purchaseFailedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }
}
