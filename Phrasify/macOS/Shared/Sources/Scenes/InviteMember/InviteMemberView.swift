//
//  InviteMemberView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 22.04.24.
//

import SwiftUI
import Model

struct InviteMemberView: View {

    @StateObject private var viewModel: InviteMemberViewModel

    @FocusState private var focused: Bool

    init(coordinator: InviteMemberViewModel.InviteMemberCoordinator, project: Project) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator, project: project))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 48) {
                    AppTitle(subtitle: "Enter the user's email to add them to your project.")
                    AppTextField(type: .email, text: $viewModel.email)
                        .focused($focused)
                }
                .padding(16)
            }
            HStack(spacing: 16) {
                Spacer()
                AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCloseButtonTapped))
                AppButton(style: .fill("Continue", .lightBlue), action: .async(viewModel.onContinueTapped))
                    .disabled(viewModel.utility.shouldPrimaryButtonDisabled)
            }
            .padding(16)
        }
        .onAppear(perform: focusTextField)
        .navigationTitle("Invite member")
        .presentationFrame(.standard)
        .applyViewBackground()
    }

    private func focusTextField() {
        focused = true
    }
}
