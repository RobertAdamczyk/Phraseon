//
//  ProjectIntegrationView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

struct ProjectIntegrationView: View {

    @ObservedObject var viewModel: ProjectIntegrationViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(subtitle: "To fully harness the capabilities of our translation key management system, please download our macOS application.\n\nThe iOS version allows you to view and manage your translation keys on-the-go, but synchronization with development environments like Xcode, Android Studio, and other platforms can only be conducted through our macOS app.")
                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Understood", .lightBlue), action: .main(viewModel.onUnderstoodTapped))
            }
            .padding(16)
        }
        .navigationTitle("Integration")
        .applyViewBackground()
    }
}

