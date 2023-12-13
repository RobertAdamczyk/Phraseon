//
//  AppButton.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI

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
                ProgressView()
                    .tint(appColor(.white))
                    .opacity(loading ? 1 : 0)
            }
            .apply(.semibold, size: .L, color: .black)
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
