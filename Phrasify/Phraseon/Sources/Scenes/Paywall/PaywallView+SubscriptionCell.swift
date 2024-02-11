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
        let isSelected: Bool

        var body: some View {
            VStack(spacing: 8) {
                VStack(alignment: .leading) {
                    Text(headline)
                        .apply(.semibold, size: .M, color: .white)
                    Text(price)
                        .apply(.bold, size: .H1, color: .white)
                    Spacer()
                    Text("Billed Monthly")
                        .apply(.regular, size: .S, color: .lightGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 128)
            .applyCellBackground()
            .overlay(alignment: .topTrailing) {
                SelectableCircle(isSelected: isSelected)
                    .padding(8)
            }
        }
    }
}
