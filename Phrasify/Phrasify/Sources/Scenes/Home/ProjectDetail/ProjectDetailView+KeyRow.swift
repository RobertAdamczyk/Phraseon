//
//  ProjectDetailView+KeyRow.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

extension ProjectDetailView {

    struct KeyRow: View {

        let key: Key

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(key.id ?? "")
                        .apply(.medium, size: .M, color: .white)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(key.lastUpdatedAt.timeAgo)
                        Rectangle()
                            .frame(width: 2)
                            .foregroundStyle(appColor(.lightGray))
                            .padding(.horizontal, 8)
                        Text(key.status.localizedTitle)
                    }
                    .apply(.medium, size: .S, color: .lightGray)
                }
                Spacer()
                Image(systemName: "chevron.forward")
                    .apply(.bold, size: .L, color: .paleOrange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .padding(.horizontal, 8)
            .background { appColor(.darkGray) }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    ZStack {
        appColor(.black)
        ProjectDetailView.KeyRow(key: .init(id: "test_key", translation: [:], createdAt: .now, lastUpdatedAt: .distantPast,
                                            status: ["EN": KeyStatus.approved]))
            .padding(16)
    }
}
