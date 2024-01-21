//
//  ValidationView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

struct ValidationView<Handler: ValidationHandlerProtocol>: View {

    @ObservedObject var validationHandler: Handler

    var body: some View {
        if let validationError = validationHandler.validationError {
            Text(validationError.localizedTitle)
                .apply(.medium, size: .M, color: .red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .offset(x: validationHandler.shake ? 0 : 30)
                .onAppear {
                    withAnimation(.interpolatingSpring(mass: 1, stiffness: 1000, damping: 7, initialVelocity: 1)) {
                        validationHandler.shake = true
                    }
                }
        }
    }
}
