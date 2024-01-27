//
//  ChangeProjectOwnerView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

struct ChangeProjectOwnerView: View {

    @ObservedObject var viewModel: ChangeProjectOwnerViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    AppTitle(subtitle: "Assign a new Project Owner to manage and oversee this project. Please enter the email address of the user you wish to designate as the new Owner. Ensure that the user is already a member of the project.")
                    AppTextField(type: .email, text: $viewModel.newProjectOwnerEmail)
                }
                .padding(16)
            }
            AppButton(style: .fill("Confirm change", .lightBlue), action: .async(viewModel.onProjectOwnerChangeTapped))
                .padding(16)
        }
        .navigationTitle("Change Owner")
        .applyViewBackground()
    }
}
