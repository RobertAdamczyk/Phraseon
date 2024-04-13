//
//  PaywallView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI
import Shimmer
import StoreKit

struct PaywallView: View {

    @ObservedObject var viewModel: PaywallViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        Text(viewModel.utility.title)
                            .apply(.medium, size: .M, color: .white)
                        VStack(spacing: 16) {
                            ForEach(viewModel.utility.products, id: \.self) { product in
                                Button(action: {
                                    viewModel.onProductTapped(product)
                                }, label: {
                                    SubscriptionCell(headline: product.displayName,
                                                     price: product.displayPrice,
                                                     period: product.subscription?.subscriptionPeriod.unit.localizedDescription,
                                                     isSelected: viewModel.utility.selectedProduct == product,
                                                     isAlreadyBought: product.id == viewModel.utility.alreadySubscribedProductId)
                                })
                                .buttonStyle(.plain)
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
                    if let disclaimerTest = viewModel.utility.disclaimerTest {
                        Text(disclaimerTest)
                            .apply(.regular, size: .S, color: .lightGray)
                            .multilineTextAlignment(.center)
                    }
                    VStack(spacing: 16) {
                        AppButton(style: .fill(viewModel.utility.buttonText, .lightBlue), action: .async(viewModel.onSubscribeButtonTapped))
                            .disabled(viewModel.utility.possiblyProcessSubscription && !viewModel.utility.hasValidSubscription)
                        AppButton(style: .text("Cancel"), action: .main(viewModel.onCloseButtonTapped))
                    }
                    Button(action: viewModel.onPrivacyPolicyTapped) {
                        Text(viewModel.utility.termsText)
                            .apply(.regular, size: .S, color: .lightGray)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }
                .padding(16)
            }
            .navigationTitle(viewModel.utility.navigationTitle)
            .redacted(reason: viewModel.utility.isLoading ? .placeholder : .invalidated)
            .shimmering(active: viewModel.utility.isLoading)
        }
        .applyViewBackground()
        .frame(idealWidth: 600, idealHeight: 700)
    }
}
