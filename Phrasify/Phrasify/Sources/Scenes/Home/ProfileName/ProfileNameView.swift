//
//  ProfileNameView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 01.01.24.
//

import SwiftUI

struct ProfileNameView: View {

    @ObservedObject var viewModel: ProfileNameViewModel

    @FocusState private var focusedTextField: AppTextField.TType?

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    AppTextField(type: .name, text: $viewModel.name)
                        .focused($focusedTextField, equals: .name)
                    AppTextField(type: .surname, text: $viewModel.surname)
                        .focused($focusedTextField, equals: .surname)
                }
                .padding(.horizontal, 16)
            }
            AppButton(style: .fill("Save", .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                .padding(16)
        }
        .navigationTitle("Profile Name")
        .onAppear(perform: focusNameTextField)
    }

    private func focusNameTextField() {
        if viewModel.name.isEmpty && viewModel.surname.isEmpty {
            focusedTextField = .name
        }
    }
}
