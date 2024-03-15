//
//  ViewBackground.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 25.01.24.
//

import SwiftUI

fileprivate struct ViewBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                appColor(.appBackground).ignoresSafeArea()
            }
    }
}

extension View {
    func applyViewBackground() -> some View {
        modifier(ViewBackground())
    }
}

