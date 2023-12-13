//
//  Coordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import Foundation
import SwiftUI

protocol Coordinator: AnyObject {

    var dependencies: Dependencies { get }

    func createRootView() -> AnyView
}
