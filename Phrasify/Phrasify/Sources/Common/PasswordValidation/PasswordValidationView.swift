//
//  PasswordValidationView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.01.24.
//

import SwiftUI

struct PasswordValidationView: View {

    @ObservedObject var validationHandler: PasswordValidationHandler

    var body: some View {
        if let validationError = validationHandler.validationError {
            Text(validationError.localizedTitle)
                .apply(.medium, size: .M, color: .red)
                .offset(x: validationHandler.shake ? 0 : 30)
                .onAppear {
                    withAnimation(.interpolatingSpring(mass: 1, stiffness: 1000, damping: 7, initialVelocity: 1)) {
                        validationHandler.shake = true
                    }
                }
        }
    }
}
