//
//  FontStyle.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation
import SwiftUI

enum FontStyle {

    case regular
    case medium
    case semibold
    case bold

    var font: AppFont {
        switch self {
        case .regular: return .rethinkSansRegular
        case .medium: return .rethinkSansMedium
        case .semibold: return .rethinkSansSemibold
        case .bold: return .rethinkSansBold
        }
    }

    func makeFontStyle(size: Size, scaling: Scaling) -> Font {
        switch scaling {
        case .dynamic: return .custom(font.rawValue, size: size.value)
        case .fixed: return .custom(font.rawValue, fixedSize: size.value)
        }
    }
}

extension FontStyle {

    enum Size {
        case S
        case M
        case L
        case H1
        case H2

        var value: CGFloat {
            switch self {
            case .S: return 14
            case .M: return 16
            case .L: return 18
            case .H1: return 28
            case .H2: return 48
            }
        }
    }

    enum Scaling {
        case dynamic
        case fixed
    }

    enum AppFont: String {
        case rethinkSansMedium = "RethinkSans-Medium"
        case rethinkSansRegular = "RethinkSans-Regular"
        case rethinkSansSemibold = "RethinkSans-SemiBold"
        case rethinkSansBold = "RethinkSans-Bold"
    }
}

extension View {

    func apply(_ fontStyle: FontStyle, size: FontStyle.Size,
               color: AppColor, scaling: FontStyle.Scaling = .dynamic) -> some View {
        self
            .font(fontStyle.makeFontStyle(size: size, scaling: scaling))
            .foregroundColor(appColor(color))
    }
}

