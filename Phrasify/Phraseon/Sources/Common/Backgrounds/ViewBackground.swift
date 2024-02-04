//
//  ViewBackground.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 25.01.24.
//

import SwiftUI

fileprivate struct ViewBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                Color.init(red: 28/255, green: 27/255, blue: 30/255).ignoresSafeArea()
            }
    }
}

extension View {
    func applyViewBackground() -> some View {
        modifier(ViewBackground())
    }
}

