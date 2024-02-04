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

    /// A keypath that finds the color value for all `Fill 1` nodes.
    let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
    /// A Color Value provider that returns the white color.
    let greyValueProvider = ColorValueProvider(LottieColor(r: 1, g: 1, b: 1, a: 1))


    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ZStack {
                    appColor(.black).opacity(0.5)
                    LottieView(animation: .named("buttonLoadingAnimation"))
                        .playing(loopMode: .loop)
                        .valueProvider(greyValueProvider, for: fillKeypath)
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
