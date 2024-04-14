//
//  CreaterojectView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 28.03.24.
//

import SwiftUI

struct CreateProjectView: View {

    @StateObject private var viewModel: CreateProjectViewModel

    init(coordinator: CreateProjectViewModel.CreateProjectCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    var body: some View {
        ViewThatFits {
            content
            ScrollView {
                content
            }
        }
        .navigationTitle("Create a new project")
        .applyViewBackground()
        .presentationFrame(.standard)
    }

    private var content: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 48) {
                AppTitle(subtitle: "Enter the project name – remember, you can change it at any time.")
                AppTextField(type: .projectName, text: $viewModel.projectName)
            }
            Spacer()
            HStack(spacing: 16) {
                Spacer()
                AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCloseButtonTapped))
                AppButton(style: .fill("Continue", .lightBlue), action: .main(viewModel.onContinueButtonTapped))
                    .disabled(viewModel.utility.shouldPrimaryButtonDisabled)
            }
        }
        .padding(16)
    }
}

