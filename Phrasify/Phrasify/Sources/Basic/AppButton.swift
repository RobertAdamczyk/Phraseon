//
//  AppButton.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Lottie

struct AppButton: View {

    let style: Style
    let action: Action

    @State private var loading: Bool = false

    var body: some View {
        SwiftUI.Button {
            switch action {
            case .main(let mainThreadAction):
                mainThreadAction()
            case .async(let asyncAction):
                Task {
                    await MainActor.run { loading = true }
                    await asyncAction()
                    await MainActor.run { loading = false }
                }
            }
        } label: {
            makeBody()
        }
    }

    @ViewBuilder
    private func makeBody() -> some View {
        switch style {
        case .fill(let text, _):
            ZStack {
                Text(text)
                    .opacity(loading ? 0 : 1)
                if loading {
                    LottieView(animation: .named("buttonLoadingAnimation"))
                        .playing(loopMode: .loop)
                        .scaleEffect(2)
                        .transition(.opacity)
                }
            }
            .apply(.medium, size: .L, color: .black)
            .frame(height: 54)
            .frame(maxWidth: .infinity, alignment: .center)
            .background {
                makeBackground()
            }
        case .text(let text):
            Text(text)
                .apply(.medium, size: .L, color: .paleOrange)
        }
    }

    @ViewBuilder
    private func makeBackground() -> some View {
        switch style {
        case .fill(_, let color):
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(color.rawValue)
        default:
            EmptyView()
        }
    }
}

extension AppButton {

    enum Style {
        case fill(String, BackgroundColor)
        case text(String)
    }

    enum BackgroundColor {
        case paleOrange
        case lightBlue

        var rawValue: Color {
            switch self {
            case .paleOrange: return appColor(.paleOrange)
            case .lightBlue: return appColor(.lightBlue)
            }
        }
    }

    enum Action {
        case main(() -> Void)
        case async(() async -> Void)
    }
}

#Preview {
    AppButton(style: .fill("TEST 1", .lightBlue), action: .async({
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }))
}
