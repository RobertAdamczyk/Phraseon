//
//  AppDivider.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct AppDivider: View {

    private let text: String?
    private let color: Color
    private let height: CGFloat

    init(with text: String? = nil, color: Color = appColor(.lightGray), height: CGFloat = 2) {
        self.text = text
        self.color = color
        self.height = height
    }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(height: height)
                .foregroundStyle(color)
            if let text {
                Text(text)
                    .padding(.horizontal, 4)
                    .apply(.semibold, size: .L, color: .lightGray)
            }
            Rectangle()
                .frame(height: height)
                .foregroundStyle(color)
        }
    }
}
