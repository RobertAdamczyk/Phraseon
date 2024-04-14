//
//  ProfileNameView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 07.04.24.
//

import SwiftUI

struct ProfileNameView: View {

    @ObservedObject var viewModel: ProfileNameViewModel

    @FocusState private var focusedTextField: AppTextField.TType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        AppTextField(type: .name, text: $viewModel.name)
                            .focused($focusedTextField, equals: .name)
                        AppTextField(type: .surname, text: $viewModel.surname)
                            .focused($focusedTextField, equals: .surname)
                    }
                    .padding(16)
                }
                HStack(spacing: 16) {
                    Spacer()
                    AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelButtonTapped))
                    AppButton(style: .fill(viewModel.utility.saveButtonTitle, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                }
                .padding(16)
            }
            .navigationTitle(viewModel.utility.navigationTitle)
        }
        .onAppear(perform: focusNameTextField)
        .applyViewBackground()
        .presentationFrame(.standard)
    }

    private func focusNameTextField() {
        if viewModel.name.isEmpty && viewModel.surname.isEmpty {
            focusedTextField = .name
        }
    }
}
