//
//  AppColor.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI

enum AppColor: String {
    case lightBlue = "appLightBlue"
    case paleOrange = "appPaleOrange"
    case white = "appWhite"
    case black = "appBlack"
    case darkGray = "appDarkGray"
    case lightGray = "appLightGray"
    case green = "appGreen"
    case red = "appRed"
}

func appColor(_ color: AppColor) -> Color {
    return .init(color.rawValue)
}

