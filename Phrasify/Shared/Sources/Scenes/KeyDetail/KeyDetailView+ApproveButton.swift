//
//  KeyDetailView+ApproveButton.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 17.01.24.
//

import SwiftUI
import Lottie
import Model

extension KeyDetailView {

    struct ApproveButton: View {

        let text: String
        let language: Language
        let action: (Language) async -> Void

        @State private var isLoading: Bool = false

        var body: some View {
            Button(action: executeAction) {
                Text(text)
                    .apply(.regular, size: .S, color: .black)
                    .opacity(isLoading ? 0 : 1)
                    .padding(4)
                    .padding(.horizontal, 4)
                    .frame(minWidth: 75)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(appColor(.paleOrange).gradient)
                    }
                    .overlay {
                        LottieView(animation: .named("buttonLoadingAnimation"))
                            .playing(loopMode: .loop)
                            .scaleEffect(2)
                            .opacity(isLoading ? 1 : 0)
                    }
            }
            .buttonStyle(.plain)
        }

        private func executeAction() {
            guard !isLoading else { return }
            Task {
                await MainActor.run { isLoading = true }
                await action(language)
                await MainActor.run { isLoading = false }
            }
        }
    }
}
