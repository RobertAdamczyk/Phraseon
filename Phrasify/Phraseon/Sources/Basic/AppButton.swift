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

    @Environment(\.isEnabled) var isEnabled

    init(style: Style, action: Action) {
        self.style = style
        self.action = action
    }

    var body: some View {
        SwiftUI.Button {
            switch action {
            case .main(let mainThreadAction):
                mainThreadAction()
            case .async(let asyncAction):
                guard !loading else { return }
                Task {
                    await MainActor.run { loading = true }
                    await asyncAction()
                    await MainActor.run { loading = false }
                }
            }
        } label: {
            makeBody()
        }
        .disabled(!isEnabled)
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
            if !isEnabled {
                RoundedRectangle(cornerRadius: 16)
                    .fill(appColor(.lightGray))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(color.rawValue.gradient)
            }
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
        case main(@MainActor () -> Void)
        case async(() async -> Void)
    }
}

#Preview {
    VStack(spacing: 16) {
        AppButton(style: .fill("TEST 1", .lightBlue), action: .async({
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }))
        AppButton(style: .fill("TEST 1", .lightBlue), action: .async({
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }))
        .disabled(true)
    }
}
