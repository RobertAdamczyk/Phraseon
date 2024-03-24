//
//  Toolbar+DisplayMode.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 24.03.24.
//

import SwiftUI

extension View {

    func toolbarLargeDisplayMode() -> some View {
        self
            .toolbar {
                Text("") // ⚠️ WORKAROUND TO MAKE TOOLBAR LARGE
            }
    }
}
