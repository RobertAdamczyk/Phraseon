//
//  ProjectDetailView+KeyRow.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

extension ProjectDetailView {

    struct KeyRow: View {

        @State private var rowHeight: CGFloat = .zero

        let key: Key

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(key.id ?? "")
                    .apply(.medium, size: .M, color: .white)
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(key.lastUpdatedAt.timeAgo)
                }
                .apply(.medium, size: .S, color: .lightGray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background { appColor(.darkGray) }
            .overlay(alignment: .topTrailing) {
                Triangle()
                    .fill(key.status.color)
                    .frame(width: rowHeight * 0.7, height: rowHeight * 0.7)
                    .overlay(alignment: .topTrailing) {
                        key.status.image
                            .apply(.medium, size: .M, color: .black)
                            .padding([.top, .trailing], 5)
                    }
            }
            .background() {
                GeometryReader { geometry in
                    Path { path in
                        DispatchQueue.main.async {
                            rowHeight = geometry.size.height
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    ZStack {
        appColor(.black)
        ProjectDetailView.KeyRow(key: .init(id: "test_key", translation: [:], createdAt: .now, lastUpdatedAt: .distantPast, status: .review))
            .padding(16)
    }
}
