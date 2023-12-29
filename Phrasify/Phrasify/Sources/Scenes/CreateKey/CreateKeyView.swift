//
//  CreateKeyView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 22.12.23.
//

import SwiftUI

struct CreateKeyView: View {

    @StateObject private var viewModel: CreateKeyViewModel

    init(coordinator: CreateKeyViewModel.CreateKeyCoordinator, project: Project) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator, project: project))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: "Enter the key identifier – remember, this must be unique.")
                    AppTextField(type: .keyId, text: $viewModel.keyId)
                    AppTextField(type: .translation(viewModel.project.baseLanguage.localizedTitle), text: $viewModel.translation)
                }
                .padding([.horizontal, .top], 16)
            }
            AppButton(style: .fill("Continue", .lightBlue), action: .async(viewModel.onContinueButtonTapped))
                .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark")
                })
            }
        }
        .navigationTitle("Create a new phrase")
    }
}

