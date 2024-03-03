//
//  File.swift
//  
//
//  Created by Robert Adamczyk on 03.03.24.
//

import Foundation

public final class TargetConfiguration {

    public func setup(target: Target) {
        currentTarget = target
    }

    public static var shared = TargetConfiguration()

    private(set) var currentTarget: Target = .live
}
