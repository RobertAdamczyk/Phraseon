//
//  presentationMinimalFrame.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

extension View {

    func presentationMinimalFrame() -> some View {
        self
            .frame(minWidth: 700, minHeight: 500) // TODO: Maybe ideal frame ?
    }
}
