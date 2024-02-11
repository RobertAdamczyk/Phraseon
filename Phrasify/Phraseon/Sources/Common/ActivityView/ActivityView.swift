//
//  ActivityView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.12.23.
//

import SwiftUI

extension View {
    func activitable(_ isLoading: Bool) -> some View {
        modifier(ActivityViewModifier(isLoading: isLoading))
    }
}

private struct ActivityViewModifier: ViewModifier {

    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ZStack {
                    appColor(.black).opacity(0.5)
                    LoadingDotsView()
                        .scaleEffect(2)
                        .frame(width: 160, height: 160)
                        .applyCellBackground()
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    appColor(.black).ignoresSafeArea()
        .activitable(true)
}
