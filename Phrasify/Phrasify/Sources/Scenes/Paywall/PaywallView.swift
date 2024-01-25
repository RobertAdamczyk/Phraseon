//
//  PaywallView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI
import Shimmer

struct PaywallView: View {

    @StateObject private var viewModel: PaywallViewModel

    init(coordinator: PaywallViewModel.PaywallCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Choose the plan that best fits your needs.")
                        .apply(.medium, size: .M, color: .white)
                    HStack(spacing: 16) {
                        ForEach(SubscriptionPlan.allCases, id: \.self) { subscription in
                            Button(action: {
                                viewModel.onPlanTapped(subscription)
                            }, label: {
                                SubscriptionCell(headline: viewModel.getInfo(for: subscription).headline,
                                                 price: viewModel.getInfo(for: subscription).price,
                                                 isSelected: viewModel.selectedSubscriptionPlan == subscription)
                            })
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(PaywallViewModel.PlanDescription.allCases, id: \.self) { plan in
                            Label {
                                Text(plan.text)
                            } icon: {
                                ZStack {
                                    Image(systemName: "checkmark")
                                        .opacity(viewModel.plans.contains(plan) ? 1 : 0)
                                        .foregroundStyle(appColor(.green))
                                    Image(systemName: "xmark")
                                        .opacity(viewModel.plans.contains(plan) ? 0 : 1)
                                        .foregroundStyle(appColor(.red))
                                }
                            }
                        }
                    }
                    .apply(.medium, size: .M, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Subscribe Now", .lightBlue), action: .async(viewModel.onSubscribeButtonTapped))
                AppButton(style: .text("Restore Purchase"), action: .main(viewModel.onRestorePurchaseButtonTapped))
            }
            .padding(16)
        }
        .navigationTitle("Subscription")
        .redacted(reason: viewModel.isLoading ? .placeholder : .invalidated)
        .shimmering(active: viewModel.isLoading)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark").bold()
                })
            }
        }
        .applyViewBackground()
    }
}

#Preview {
    NavigationView {
        PaywallView(coordinator: MockCoordinator())
    }
    .preferredColorScheme(.dark)
}
