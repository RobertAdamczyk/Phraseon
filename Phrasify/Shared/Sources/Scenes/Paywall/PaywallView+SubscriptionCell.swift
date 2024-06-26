//
//  PaywallView+SubscriptionCell.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 25.01.24.
//

import SwiftUI

extension PaywallView {

    struct SubscriptionCell: View {

        let headline: String
        let price: String
        let period: String?
        let isSelected: Bool
        let isAlreadyBought: Bool

        var body: some View {
            VStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(headline)
                            .apply(.medium, size: .M, color: .white)
                        Text(price)
                            .apply(.semibold, size: .H1, color: .white)
                    }
                    HStack {
                        Text("Billed per " + (period ?? "-"))
                        Spacer()
                        if isAlreadyBought {
                            Text("Already Bought")
                        }
                    }
                    .apply(.regular, size: .S, color: .lightGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .applyCellBackground()
            .overlay(alignment: .topTrailing) {
                SelectableCircle(isSelected: isSelected)
                    .padding(16)
            }
        }
    }
}

#Preview {

    ZStack {
        PaywallView.SubscriptionCell(headline: "Monthly", price: "$9.99", period: "month", isSelected: true, isAlreadyBought: true)
    }
}
