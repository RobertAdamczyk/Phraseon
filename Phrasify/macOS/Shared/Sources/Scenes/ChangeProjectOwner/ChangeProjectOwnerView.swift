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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    AppTitle(subtitle: "Assign a new Project Owner to manage and oversee this project. Please enter the email address of the user you wish to designate as the new Owner. Ensure that the user is already a member of the project.")
                    AppTextField(type: .email, text: $viewModel.newProjectOwnerEmail)
                }
                .padding(16)
                .padding(.bottom, ActionBottomBarConstants.height)
            }
            .makeActionBottomBar(padding: .small) {
                Spacer()
                AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelButtonTapped))
                AppButton(style: .fill("Confirm change", .lightBlue), action: .async(viewModel.onProjectOwnerChangeTapped))
            }
            .navigationTitle("Change Owner")
        }
        .presentationFrame(.standard)
        .applyViewBackground()
    }
}
