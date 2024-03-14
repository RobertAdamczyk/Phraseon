//
//  Coordinator.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation

protocol Coordinator: AnyObject {

    var dependencies: Dependencies { get }
}
