//
//  AppDivider.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct AppDivider: View {

    private let text: String?
    private let color: Color

    init(with text: String? = nil, color: Color = appColor(.lightGray)) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(color)
            .overlay {
                if let text {
                    Text(text)
                        .padding(.horizontal, 4)
                        .apply(.semibold, size: .L, color: .lightGray)
                        .background(appColor(.black))
                }
            }
    }
}
