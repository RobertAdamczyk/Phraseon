//
//  DeferredData.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 08.02.24.
//

import Foundation

public enum DeferredData<T>: Equatable where T: Equatable {

    case idle
    case isLoading
    case loaded(T)
    case failed(Error)

    public var currentValue: T? {
        switch self {
        case .isLoading, .idle, .failed: return nil
        case let .loaded(value): return value
        }
    }

    public var error: Error? {
        switch self {
        case .failed(let error): return error
        default: return nil
        }
    }

    public static func == (lhs: DeferredData<T>, rhs: DeferredData<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.isLoading, .isLoading): return true
        case (.loaded(let lhsValue), .loaded(let rhsValue)):
            return lhsValue == rhsValue
        case (.failed, .failed):
            // Since error is not equatable, we treat `failed` as not equal.
            // If you need a more precise distinction you have to implement the comparison yourself.
            return false
        default:
            return false
        }
    }

    public var isFailed: Bool {
        switch self {
        case .idle, .isLoading, .loaded: return false
        case .failed: return true
        }
    }
}
