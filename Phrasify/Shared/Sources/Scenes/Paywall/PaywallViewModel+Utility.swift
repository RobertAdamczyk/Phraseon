//
//  PaywallViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import StoreKit
import Model
import Common

extension PaywallViewModel {

    struct Utility {

        private let state: State
        private let user: DeferredData<User>
        private let lastSubscriptionPurchaseDate: Double?

        init(state: State, user: DeferredData<User>, lastSubscriptionPurchaseDate: Double?) {
            self.state = state
            self.user = user
            self.lastSubscriptionPurchaseDate = lastSubscriptionPurchaseDate
        }

        let navigationTitle: String = "Subscription"
        let title: String = "Adaptability or Savings? The choice is yours."
        let termsText: String = "Terms of Service & Privacy Policy"

        var selectedProduct: Product? {
            if case .idle(_, let product) = state {
                return product
            }
            return nil
        }

        var isLoading: Bool {
            if case .loading = state {
                return true
            }
            return false
        }

        var products: [Product] {
            if case .idle(let products, _) = state {
                return products
            }
            return []
        }

        var hasValidSubscription: Bool {
            guard let subscriptionValidUntil = user.currentValue?.subscriptionValidUntil,
                    let status = user.currentValue?.subscriptionStatus else { return false }
            return subscriptionValidUntil > .now && status != .trial
        }

        var alreadySubscribedProductId: String? {
            guard hasValidSubscription else { return nil }
            return user.currentValue?.subscriptionPlan?.id
        }

        var trialAvailable: Bool {
            let user = user.currentValue
            return user?.subscriptionStatus == nil && user?.subscriptionPlan == nil && user?.subscriptionValidUntil == nil
        }

        var possiblyProcessSubscription: Bool {
            guard let lastSubscriptionPurchaseDate else { return false }
            return abs(Date(timeIntervalSince1970: lastSubscriptionPurchaseDate).timeIntervalSinceNow) < 180
        }

        var buttonText: String {
            if trialAvailable {
                return "Try for free"
            } else if hasValidSubscription {
                return "Manage Subscriptions"
            } else if possiblyProcessSubscription {
                return "Processing Subscription"
            } else {
                return "Subscribe Now"
            }
        }

        var disclaimerTest: String? {
            if trialAvailable {
                return "Start your 7-day free trial now and explore all the features of our platform with no commitment – you won't be charged when your trial ends."
            }
            if let userSubscriptionPlan = user.currentValue?.subscriptionPlan, hasValidSubscription {
                switch userSubscriptionPlan {
                case .monthly:
                    return "You are currently subscribed to our Monthly plan. Consider upgrading to the Yearly plan for better pricing over the long term!"
                case .yearly:
                    return "You are enjoying full access to our app with the Yearly subscription – thank you for trusting and supporting our project!"
                }
            }
            if possiblyProcessSubscription {
                return "Please note that it may take a few minutes to process your subscription purchase."
            }
            return nil
        }
    }
}
