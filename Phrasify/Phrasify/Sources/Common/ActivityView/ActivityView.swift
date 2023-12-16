//
//  ActivityView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.12.23.
//

import SwiftUI
import Lottie

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
                    LottieView(animation: .named("buttonLoadingAnimation"))
                        .playing(loopMode: .loop)
                        .scaleEffect(2)
                        .frame(width: 160, height: 160)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(appColor(.white))
                        }
                }
                .ignoresSafeArea()
            }
        }
    }
}
