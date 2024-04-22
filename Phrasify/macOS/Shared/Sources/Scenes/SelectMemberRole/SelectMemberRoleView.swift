//
//  SelectMemberRoleView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 22.04.24.
//

import SwiftUI
import Model

struct SelectMemberRole: View {

    @ObservedObject var viewModel: SelectMemberRoleViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        if let user = viewModel.utility.user {
                            UserDetailView(email: user.email, name: user.name, surname: user.surname, photoUrl: user.photoUrl)
                        }
                        AppTitle(subtitle: "Assign a role to define how users will interact with the project. Each role comes with different permissions and access levels.")
                        VStack(spacing: 12) {
                            ForEach(Role.allCases.filter({ $0 != .owner }).sorted(by: { $0.sortIndex < $1.sortIndex }), id: \.self) { role in
                                Button(action: {
                                    viewModel.onRoleTapped(role)
                                }, label: {
                                    makeRoleRow(for: role)
                                })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(16)
                }
                HStack(spacing: 16) {
                    Spacer()
                    AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelButtonTapped))
                    AppButton(style: .fill(viewModel.utility.buttonText, .lightBlue), action: .async(viewModel.onSaveButtonTapped))
                        .disabled(viewModel.utility.shouldButtonDisabled)
                }
                .padding(16)
            }
            .navigationTitle("Choose role")
        }
        .presentationFrame(.standard)
        .applyViewBackground()
    }

    private func makeRoleRow(for role: Role) -> some View {
        HStack(spacing: 16) {
            SelectableCircle(isSelected: viewModel.selectedRole == role)
            Text(role.title)
                .apply(.medium, size: .L, color: viewModel.selectedRole == role ? .white : .lightGray)
            Spacer()
        }
        .padding(16)
        .applyCellBackground()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .fill(viewModel.selectedRole == role ? appColor(.lightGray) : .clear)
        }
    }
}
