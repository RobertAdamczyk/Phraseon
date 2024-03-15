//
//  CellBackground.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 25.01.24.
//

import SwiftUI

fileprivate struct CellBackground: ViewModifier {

    private let veryDarkGray: Color = .init(red: 39/255, green: 39/255, blue: 39/255)
    private let darkGray: Color = .init(red: 46/255, green: 46/255, blue: 46/255)
    private let gray: Color = .init(red: 70/255, green: 70/255, blue: 70/255)

    func body(content: Content) -> some View {
        content
            .background {
                LinearGradient(gradient: Gradient(colors: [veryDarkGray, darkGray]), startPoint: .bottom, endPoint: .top)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .fill(LinearGradient(gradient: Gradient(colors: [veryDarkGray, gray]), startPoint: .bottom, endPoint: .top))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func applyCellBackground() -> some View {
        modifier(CellBackground())
    }
}
