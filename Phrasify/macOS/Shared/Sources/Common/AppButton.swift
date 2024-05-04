//
//  AppButton.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 13.04.24.
//

import SwiftUI
import Lottie

struct AppButton: View {

    static let height: CGFloat = 40
    static let authenticationProviderButtonHeight: CGFloat = 32

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
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func makeBody() -> some View {
        switch style {
        case .fill(let text, _):
            makeFillButton(text: text, width: nil, height: Self.height)
        case .authentication(let text, _):
            makeFillButton(text: text, width: .infinity, height: Self.authenticationProviderButtonHeight)
        case .text(let text):
            Text(text)
                .apply(.medium, size: .L, color: .paleOrange)
        }
    }

    @ViewBuilder
    private func makeFillButton(text: String, width: CGFloat?, height: CGFloat?) -> some View {
        ZStack {
            Text(text)
                .padding(.horizontal, 32)
                .opacity(loading ? 0 : 1)
            if loading {
                LottieView(animation: .named("buttonLoadingAnimation"))
                    .playing(loopMode: .loop)
                    .scaleEffect(3)
                    .frame(width: 50, height: height)
                    .transition(.opacity)
            }
        }
        .apply(.medium, size: .M, color: .black)
        .frame(maxWidth: width)
        .frame(height: height)
        .background {
            makeBackground()
        }
    }

    @ViewBuilder
    private func makeBackground() -> some View {
        switch style {
        case .fill(_, let color):
            if !isEnabled {
                RoundedRectangle(cornerRadius: 8)
                    .fill(appColor(.lightGray))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.rawValue.gradient)
            }
        case .authentication(_, let color):
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
        case authentication(String, BackgroundColor)
        case fill(String, BackgroundColor)
        case text(String)
    }

    enum BackgroundColor {
        case paleOrange
        case lightBlue
        case lightGray

        var rawValue: Color {
            switch self {
            case .paleOrange: return appColor(.paleOrange)
            case .lightBlue: return appColor(.lightBlue)
            case .lightGray: return appColor(.lightGray)
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
