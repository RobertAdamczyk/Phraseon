//
//  Secrets.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 08.02.24.
//

import Foundation

public final class Secrets {

    public static var shared = Secrets()

    private init() { }

    public func setup(path: String?) {
        guard let path, let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            fatalError("Secrets setup error")
        }
        setupProperties(for: dictionary)
    }

    private func setupProperties(for dictionary: [String: Any]) {

        guard let algoliaAppId = dictionary["ALGOLIA_APP_ID"] as? String else { fatalError("algoliaAppId not found") }
        self.algoliaAppId = algoliaAppId

        guard let algoliaSearchKey = dictionary["ALGOLIA_SEARCH_KEY"] as? String else { fatalError("algoliaSearchKey not found") }
        self.algoliaSearchKey = algoliaSearchKey
    }

    public var algoliaAppId: String = ""

    public var algoliaSearchKey: String = ""
}
