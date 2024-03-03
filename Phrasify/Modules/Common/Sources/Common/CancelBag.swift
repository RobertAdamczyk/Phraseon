//
//  CancelBag.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation
import Combine

public final class CancelBag {

    public var subscriptions = Set<AnyCancellable>()

    public init() {}

    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    public func collect(@Builder _ cancellables: () -> [AnyCancellable]) {
        subscriptions.formUnion(cancellables())
    }

    @resultBuilder
    public struct Builder {
        public static func buildBlock(_ cancellables: AnyCancellable...) -> [AnyCancellable] {
            return cancellables
        }
    }
}

extension AnyCancellable {

    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
