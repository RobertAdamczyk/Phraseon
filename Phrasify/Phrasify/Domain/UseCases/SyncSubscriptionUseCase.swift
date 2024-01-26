//
//  SyncSubscriptionUseCase.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 26.01.24.
//

import Foundation

final class SyncSubscriptionUseCase {

    private let firestoreRepository: FirestoreRepository
    private let glassfyRepository: GlassfyRepository
    private let authenticationRepository: AuthenticationRepository

    init(firestoreRepository: FirestoreRepository, glassfyRepository: GlassfyRepository,
         authenticationRepository: AuthenticationRepository) {
        self.firestoreRepository = firestoreRepository
        self.glassfyRepository = glassfyRepository
        self.authenticationRepository = authenticationRepository
    }

    func sync() {
        guard let userId = authenticationRepository.currentUser?.uid else { return }
        Task {
            do {
                let permission = try await glassfyRepository.checkPermission()
                guard let validUntil = permission.expireDate, permission.isValid else { return }
                let subscriptionPlan: SubscriptionPlan = {
                    let test = permission.accountableSkus.compactMap { SubscriptionPlan(rawValue: $0.productId) }
                    return test.sorted(by: { $0.sortIndex > $1.sortIndex }).first ?? .basic
                }()
                try await firestoreRepository.setSubscriptionInfo(userId: userId,
                                                                  subscriptionStatus: .premium,
                                                                  subscriptionPlan: subscriptionPlan,
                                                                  validUntil: validUntil)
            } catch {
                print("Sync error: \(error)") // Don't need toast.
            }
        }
    }
}
