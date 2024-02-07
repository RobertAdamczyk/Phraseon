//
//  LoadingDotsView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.02.24.
//

import SwiftUI
import Lottie

struct LoadingDotsView: View {

    private let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
    /// A Color Value provider that returns the white color.
    private let greyValueProvider = ColorValueProvider(LottieColor(r: 1, g: 1, b: 1, a: 1))

    var body: some View {
        LottieView(animation: .named("buttonLoadingAnimation"))
            .playing(loopMode: .loop)
            .valueProvider(greyValueProvider, for: fillKeypath)
    }
}
