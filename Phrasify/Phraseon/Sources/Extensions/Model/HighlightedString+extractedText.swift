//
//  HighlightedString+extractedText.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.02.24.
//

import Foundation
import AlgoliaSearchClient

extension HighlightedString {

    var extractedText: String? {
        let regex = try? NSRegularExpression(pattern: "\(self.taggedString.preTag)(.*?)\(self.taggedString.postTag)", options: [])
        let nsString = self.taggedString.input as NSString
        let results = regex?.matches(in: self.taggedString.input, options: [], range: NSRange(location: 0, length: nsString.length))
        return results?.map { nsString.substring(with: $0.range(at: 1)) }.first
    }
}
