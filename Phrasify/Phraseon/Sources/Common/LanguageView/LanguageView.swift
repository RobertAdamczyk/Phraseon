//
//  LanguageView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 10.01.24.
//

import SwiftUI

struct LanguageView: View {

    let language: Language
    let isBaseLanguage: Bool

    var body: some View {
        HStack(spacing: 16) {
            Image(language.rawValue)
                .resizable()
                .frame(width: 24, height: 24)
                .padding(2)
                .background {
                    Circle()
                        .fill(appColor(.white))
                }
            Text("\(language.localizedTitle) \(isBaseLanguage ? "(Base)" : "")")
                .apply(.medium, size: .L, color: .lightGray)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .applyCellBackground()
    }
}
