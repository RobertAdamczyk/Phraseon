//
//  CreateProjectView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

struct CreateProjectView: View {

    @StateObject private var viewModel: CreateProjectViewModel

    init(coordinator: CreateProjectViewModel.CreateProjectCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: "Enter the project name – remember, you can change it at any time.")
                    AppTextField(type: .projectName, text: $viewModel.projectName)
                }
                .padding([.horizontal, .top], 16)
            }
            AppButton(style: .fill("Continue", .lightBlue), action: .main(viewModel.onContinueButtonTapped),
                      disabled: viewModel.shouldPrimaryButtonDisabled)
            .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark")
                })
            }
        }
        .navigationTitle("Create a new project")
    }
}
