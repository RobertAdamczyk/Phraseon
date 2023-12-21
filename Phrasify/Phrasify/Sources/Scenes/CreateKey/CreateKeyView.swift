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
        VStack(alignment: .leading, spacing: 16) {
            AppTitle(title: "Create a new phrase",
                     subtitle: "Enter the key identifier – remember, this must be unique.")
            AppTextField(type: .keyId, text: $viewModel.keyId)
                .padding(.top, 32)
            AppTextField(type: .translation(viewModel.project.languages.first?.localizedTitle ?? ""), text: $viewModel.translation)
                .padding(.top, 32)
            Spacer()
            AppButton(style: .fill("Continue", .lightBlue), action: .main(viewModel.onContinueButtonTapped))
        }
        .padding(16)
        .background {
            appColor(.black).ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark")
                })
            }
        }
    }
}

