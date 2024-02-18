//
//  InviteMemberView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

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
            AppButton(style: .fill("Continue", .lightBlue), action: .async(viewModel.onContinueTapped))
                .disabled(viewModel.shouldPrimaryButtonDisabled)
                .padding(16)
        }
        .onAppear(perform: focusTextField)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onCloseButtonTapped, label: {
                    Image(systemName: "xmark").bold()
                })
            }
        }
        .navigationTitle("Invite member")
        .applyViewBackground()
    }

    private func focusTextField() {
        focused = true
    }
}

#if DEBUG
#Preview {
    InviteMemberView(coordinator: MockCoordinator(), project: .init(name: "", 
                                                                    technologies: [],
                                                                    languages: [], 
                                                                    baseLanguage: .english,
                                                                    members: [], owner: "",
                                                                    securedAlgoliaApiKey: "",
                                                                    createdAt: .now))
}
#endif
