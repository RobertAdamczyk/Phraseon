//
//  MockCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

#if DEBUG

final class MockCoordinator: Coordinator {

    var dependencies: Dependencies = .init(repository: "")

    func createRootView() -> AnyView {
        .init(EmptyView())
    }
}

#endif
