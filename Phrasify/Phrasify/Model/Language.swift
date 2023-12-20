//
//  Language.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import Foundation

enum Language: String, CaseIterable, Codable {

    case english = "EN"
    case mandarinChinese = "ZH"
    case hindi = "HI"
    case spanish = "ES"
    case french = "FR"
    case arabic = "AR"
    case bengali = "BN"
    case russian = "RU"
    case portuguese = "PT"
    case indonesian = "ID"
}

extension Language {

    var localizedTitle: String {
        return switch self {
        case .english: "English"
        case .mandarinChinese: "Mandarin Chinese"
        case .hindi: "Hindi"
        case .spanish: "Spanish"
        case .french: "French"
        case .arabic: "Arabic"
        case .bengali: "Bengali"
        case .russian: "Russian"
        case .portuguese: "Portuguese"
        case .indonesian: "Indonesian"
        }
    }
}
