//
//  ChangeProjectOwnerView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 21.04.24.
//

import SwiftUI

struct ChangeProjectOwnerView: View {

    @ObservedObject var viewModel: ChangeProjectOwnerViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        AppTitle(subtitle: "Assign a new Project Owner to manage and oversee this project. Please enter the email address of the user you wish to designate as the new Owner. Ensure that the user is already a member of the project.")
                        AppTextField(type: .email, text: $viewModel.newProjectOwnerEmail)
                    }
                    .padding(16)
                }
                HStack(spacing: 16) {
                    Spacer()
                    AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelButtonTapped))
                    AppButton(style: .fill("Confirm change", .lightBlue), action: .async(viewModel.onProjectOwnerChangeTapped))
                }
                .padding(16)
            }
            .navigationTitle("Change Owner")
        }
        .presentationFrame(.standard)
        .applyViewBackground()
    }
}
