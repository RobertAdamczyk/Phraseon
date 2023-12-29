//
//  AppDivider.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct AppDivider: View {

    private let text: String?

    init(with text: String? = nil) {
        self.text = text
    }

    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(appColor(.lightGray))
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
