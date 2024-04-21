//
//  presentationMinimalFrame.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

extension View {

    func presentationFrame(_ size: SheetSizer.Size) -> some View {
        modifier(SheetSizer(size: size))
    }
}

struct SheetSizer: ViewModifier {

    enum Size {
        case standard
    }

    fileprivate init(size: Size) {
        self.size = size
    }

    let size: Size

    func body(content: Content) -> some View {
        switch size {
        case .standard:
            content
                .frame(idealWidth: 700, idealHeight: 500)
        }
    }
}
