//
//  File.swift
//  
//
//  Created by Robert Adamczyk on 03.03.24.
//

import Foundation

public final class TargetConfiguration {

    public var currentTarget: Target {
        target
    }

    public func setup(target: Target) {
        self.target = target
    }

    public static var shared = TargetConfiguration()

    private var target: Target = .live // .LIVE is Fallback, this should be set on app start.
}
