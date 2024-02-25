//
//  PaywallView.swift
//  Phraseon
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
                    Text("Adaptability or Savings? The choice is yours.")
                        .apply(.medium, size: .M, color: .white)
                    VStack(spacing: 16) {
                        ForEach(viewModel.products, id: \.self) { product in
                            Button(action: {
                                viewModel.onProductTapped(product)
                            }, label: {
                                SubscriptionCell(headline: product.displayName,
                                                 price: product.displayPrice,
                                                 period: product.subscription?.subscriptionPeriod.unit.localizedDescription,
                                                 isSelected: viewModel.selectedProduct == product)
                            })
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(PaywallViewModel.PlanFeature.allCases, id: \.self) { plan in
                            Label {
                                Text(plan.description)
                            } icon: {
                                ZStack {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(appColor(.green))
                                }
                            }
                        }
                    }
                    .apply(.regular, size: .S, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
            }
            VStack(spacing: 16) {
                if let disclaimerTest = viewModel.disclaimerTest {
                    Text(disclaimerTest)
                        .apply(.regular, size: .S, color: .lightGray)
                        .multilineTextAlignment(.center)
                }
                AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onSubscribeButtonTapped))
                    .disabled(viewModel.hasValidSelectedSubscription)
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

#if DEBUG
#Preview {
    NavigationView {
        PaywallView(coordinator: PreviewCoordinator())
    }
    .preferredColorScheme(.dark)
}
#endif
