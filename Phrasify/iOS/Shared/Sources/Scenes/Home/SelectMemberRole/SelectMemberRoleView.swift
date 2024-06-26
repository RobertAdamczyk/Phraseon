//
//  SelectMemberRole.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import Model

struct SelectMemberRole: View {

    @ObservedObject var viewModel: SelectMemberRoleViewModel

    var body: some View {
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
                        }
                    }
                }
                .padding(16)
            }
            AppButton(style: .fill(viewModel.utility.buttonText, .lightBlue), action: .async(viewModel.onSaveButtonTapped))
                .disabled(viewModel.utility.shouldButtonDisabled)
                .padding(16)
        }
        .navigationTitle("Choose role")
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

#if DEBUG
#Preview {
    SelectMemberRole(viewModel: .init(coordinator: PreviewCoordinator(),
                                      project: .init(name: "", technologies: [], languages: [], baseLanguage: .polish, members: [], owner: "", securedAlgoliaApiKey: "", createdAt: .now, algoliaIndexName: ""),
                                      context: .invite(user: .init(email: "", name: "", surname: "", createdAt: .now, subscriptionId: .init(), subscriptionStatus: .expires, subscriptionValidUntil: .now))))
    .preferredColorScheme(.dark)
}
#endif
