//
//  Activitable.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.12.23.
//

import Foundation

protocol Activitable: AnyObject {

    var shouldShowActivityView: Bool { get set }

    func startActivity()

    func stopActivity()
}

extension Activitable {

    @MainActor
    func startActivity() {
        shouldShowActivityView = true
    }

    @MainActor
    func stopActivity() {
        shouldShowActivityView = false
    }
}
