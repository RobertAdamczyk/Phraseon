//
//  SelectMemberRole.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

struct SelectMemberRole: View {

    @ObservedObject var viewModel: SelectMemberRoleViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    if let user = viewModel.user {
                        UserDetailView(email: user.email, name: user.name, surname: user.surname, photoUrl: user.photoUrl)
                    }
                    AppTitle(subtitle: "Assign a role to define how users will interact with the project. Each role comes with different permissions and access levels.")
                    VStack(spacing: 12) {
                        ForEach(Role.allCases.filter({ $0 != .owner }), id: \.self) { role in
                            Button(action: {
                                viewModel.onRoleTapped(role)
                            }, label: {
                                makeRoleRow(for: role)
                            })
                        }
                    }
                }
                .padding(16)
            }
            AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onSaveButtonTapped),
                      disabled: viewModel.shouldButtonDisabled)
                .padding(16)
        }
        .navigationTitle("Choose role")
    }

    private func makeRoleRow(for role: Role) -> some View {
        HStack {
            Text(role.title)
                .apply(.medium, size: .L, color: viewModel.selectedRole == role ? .white : .lightGray)
            Spacer()
        }
        .padding(12)
        .background {
            Rectangle()
                .fill(appColor(.darkGray))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .fill(viewModel.selectedRole == role ? appColor(.lightGray) : .clear)
        }
    }
}
#Preview {
    SelectMemberRole(viewModel: .init(coordinator: MockCoordinator(),
                                      project: .init(name: "", technologies: [], languages: [], baseLanguage: .arabic, members: [], owner: ""),
                                      context: .invite(user: .init(email: "", name: "", surname: "", createdAt: .now, subscriptionStatus: .basic, subscriptionValidUntil: .now))))
    .preferredColorScheme(.dark)
}
