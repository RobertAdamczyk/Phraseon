//
//  AppleButton.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 05.03.24.
//

import SwiftUI
import AuthenticationServices

struct AppleButton: View {

    let onRequest: (ASAuthorizationAppleIDRequest) -> Void
    let onCompletion: @MainActor (Result<ASAuthorization, any Error>) -> Void

    var body: some View {
        SignInWithAppleButton(.continue,
                              onRequest: onRequest,
                              onCompletion: onCompletion)
        .signInWithAppleButtonStyle(.white)
        .frame(height: AppButton.height)
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    AppleButton { _ in
    } onCompletion: { _ in
    }
}
