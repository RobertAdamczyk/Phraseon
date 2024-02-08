//
//  Secrets.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 08.02.24.
//

import Foundation

struct Secrets {

    private static func secrets() -> [String: Any] {
        let fileName = "secrets"
        let path = Bundle.main.path(forResource: fileName, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    }

    static var algoliaAppId: String {
        return secrets()["ALGOLIA_APP_ID"] as! String
    }

    static var algoliaAdminKey: String {
        return secrets()["ALGOLIA_ADMIN_KEY"] as! String
    }
}
