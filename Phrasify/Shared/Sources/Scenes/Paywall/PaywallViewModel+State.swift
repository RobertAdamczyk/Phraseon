//
//  PaywallViewModel+State.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import StoreKit

extension PaywallViewModel {

    enum State {
        case loading
        case error
        case idle([Product], Product)
    }
}
