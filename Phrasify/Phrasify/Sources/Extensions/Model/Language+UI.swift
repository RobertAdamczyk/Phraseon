//
//  Language+UI.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import Foundation

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

extension Array where Element == Language {

    var joined: String {
        self.compactMap { $0.rawValue }.joined(separator: "/")
    }
}
