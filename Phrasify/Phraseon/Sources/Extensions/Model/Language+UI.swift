//
//  Language+UI.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import Foundation

extension Language {

    var localizedTitle: String {
        switch self {
        case .arabic: return "Arabic"
        case .bulgarian: return "Bulgarian"
        case .czech: return "Czech"
        case .danish: return "Danish"
        case .german: return "German"
        case .greek: return "Greek"
        case .englishBritish: return "English (British)"
        case .englishAmerican: return "English (American)"
        case .spanish: return "Spanish"
        case .estonian: return "Estonian"
        case .finnish: return "Finnish"
        case .french: return "French"
        case .hungarian: return "Hungarian"
        case .indonesian: return "Indonesian"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .korean: return "Korean"
        case .lithuanian: return "Lithuanian"
        case .latvian: return "Latvian"
        case .norwegianBokmal: return "Norwegian (Bokmål)"
        case .dutch: return "Dutch"
        case .polish: return "Polish"
        case .portugueseBrazilian: return "Portuguese (Brazilian)"
        case .portugueseEuropean: return "Portuguese (European)"
        case .romanian: return "Romanian"
        case .russian: return "Russian"
        case .slovak: return "Slovak"
        case .slovenian: return "Slovenian"
        case .swedish: return "Swedish"
        case .turkish: return "Turkish"
        case .ukrainian: return "Ukrainian"
        case .mandarinChineseSimplified: return "Mandarin Chinese (Simplified)"
        }
    }

}

extension Array where Element == Language {

    var joined: String {
        self.compactMap { $0.rawValue }.joined(separator: "/")
    }
}
