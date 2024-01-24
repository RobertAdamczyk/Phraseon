//
//  PaywallView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 24.01.24.
//

import SwiftUI

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
                        ForEach(SubscriptionStatus.buyable, id: \.self) { subscription in
                            Button(action: {
                                viewModel.onPlanTapped(subscription)
                            }, label: {
                                SubscriptionCell {
                                    VStack(alignment: .leading) {
                                        Text(viewModel.getInfo(for: subscription).headline)
                                            .apply(.semibold, size: .M, color: .white)
                                        Text(viewModel.getInfo(for: subscription).price)
                                            .apply(.bold, size: .H1, color: .white)
                                        Spacer()
                                        Text("Billed Monthly")
                                            .apply(.regular, size: .S, color: .lightGray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                }
                                .overlay(alignment: .topTrailing) {
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(appColor(viewModel.selectedSubscriptionPlan == subscription ? .white : .lightGray))
                                        .background {
                                            Circle()
                                                .foregroundStyle(appColor(.paleOrange))
                                                .padding(5)
                                                .opacity(viewModel.selectedSubscriptionPlan == subscription ? 1 : 0)
                                        }
                                        .padding(8)

                                }
                            })
                        }
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.getPlan(for: viewModel.selectedSubscriptionPlan), id: \.self) { text in
                            Label(text, systemImage: "checkmark")
                        }
                    }
                    .apply(.medium, size: .L, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Subscribe Now", .lightBlue), action: .main({
                    print("XD")
                }))
                AppButton(style: .text("Not now"), action: .main({
                    print("XD")
                }))
            }
            .padding(16)
        }
        .background {
            Color.init(red: 28/255, green: 27/255, blue: 30/255).ignoresSafeArea()
        }
    }
}

extension PaywallView {

    struct SubscriptionCell<Content: View>: View {

        @ViewBuilder var content: Content

        var body: some View {
            VStack(spacing: 8) {
                content
            }
            .frame(maxWidth: .infinity)
            .frame(height: 128)
            .background {
                LinearGradient(gradient: Gradient(colors: [.init(red: 39/255,
                                                                 green: 39/255,
                                                                 blue: 39/255),
                                                           .init(red: 46/255,
                                                                 green: 46/255,
                                                                 blue: 46/255)]),
                               startPoint: .bottom, endPoint: .top)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .fill(LinearGradient(gradient: Gradient(colors: [.init(red: 39/255,
                                                                               green: 39/255,
                                                                               blue: 39/255),
                                                                         .init(red: 70/255,
                                                                               green: 70/255,
                                                                               blue: 70/255)]),
                                             startPoint: .bottom, endPoint: .top))
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        PaywallView(coordinator: MockCoordinator())
            .navigationTitle("Subscription")
    }
    .preferredColorScheme(.dark)
}
