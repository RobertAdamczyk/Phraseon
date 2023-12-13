//
//  AppColor.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI

enum AppColor: String {
    case lightBlue
    case paleOrange
    case white
    case black
    case darkGray
}

func appColor(_ color: AppColor) -> Color {
    return .init(color.rawValue)
}
