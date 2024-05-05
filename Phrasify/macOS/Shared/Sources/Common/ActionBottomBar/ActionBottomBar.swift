//
//  ActionBottomBar.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 05.05.24.
//

import SwiftUI

private struct ActionBottomBar<Content: View>: View {

    private var padding: ActionBottomBarConstants.Padding
    private var content: Content

    init(padding: ActionBottomBarConstants.Padding, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 16) {
            content
        }
        .padding(.horizontal, padding.value)
        .frame(height: ActionBottomBarConstants.height)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Rectangle().frame(height: 1)
                .foregroundStyle(appColor(.black))
        }
    }
}

extension View {
    func makeActionBottomBar<V>(padding: ActionBottomBarConstants.Padding, @ViewBuilder content: () -> V) -> some View where V : View {
        self
            .overlay(alignment: .bottom) {
                ActionBottomBar(padding: padding, content: {
                    content()
                })
            }
    }
}

struct ActionBottomBarConstants {
    static let height: CGFloat = 84

    enum Padding {
        case small
        case large

        var value: CGFloat {
            return switch self {
            case .large: 32
            case .small: 16
            }
        }
    }
}
