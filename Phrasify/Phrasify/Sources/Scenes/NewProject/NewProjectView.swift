//
//  NewProjectView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

struct NewProjectView: View {

    @StateObject private var viewModel: NewProjectViewModel

    init(coordinator: NewProjectViewModel.NewProjectCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AppTitle(title: "Create a new project",
                     subtitle: "Enter the project name – remember, you can change it at any time.")
            AppTextField(type: .projectName, text: $viewModel.projectName)
                .padding(.top, 32)
            Spacer()
            AppButton(style: .fill("Continue", .paleOrange), action: .main(viewModel.onContinueButtonTapped),
                      disabled: viewModel.shouldPrimaryButtonDisabled)
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
