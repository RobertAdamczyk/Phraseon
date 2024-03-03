//
//  Localized.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation

public func localized(string key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func localized(string key: String, _ args: String...) -> String {
    var localizedString = NSLocalizedString(key, comment: "")
    args.forEach { arg in
        localizedString = localizedString.replacingOccurrences(of: "%s", with: arg)
    }
    return localizedString
}
