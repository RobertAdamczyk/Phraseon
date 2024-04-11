//
//  CreateKeyViewModel+Utility.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 11.04.24.
//

import Foundation

extension CreateKeyViewModel {

    struct Utility {

        private let keyId: String

        init(keyId: String) {
            self.keyId = keyId
        }

        var shouldDisablePrimaryButton: Bool {
            keyId.count < 3 || keyId.contains(" ")
        }
    }
}
