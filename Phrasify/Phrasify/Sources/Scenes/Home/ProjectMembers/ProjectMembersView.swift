//
//  ProjectMembersView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

struct ProjectMembersView: View {

    @ObservedObject var viewModel: ProjectMembersViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Role.allCases, id: \.self) { role in
                        if let membersOfRole = viewModel.groupedMembers[role], !membersOfRole.isEmpty {
                            Text(role.sectionTitle)
                                .apply(.medium, size: .M, color: .lightGray)
                                .padding(.top, role == .owner ? 0 : 16)

                            ForEach(membersOfRole, id: \.self) { member in
                                SwipeAction(cornerRadius: 8) {
                                    UserDetailView(email: member.email, name: member.name, surname: member.surname, photoUrl: member.photoUrl)
                                } actions: {
                                    Action(tint: appColor(.lightGray), icon: "square.and.pencil",
                                           isEnabled: viewModel.member?.hasPermissionToManageMembers == true && member.role != .owner) {
                                        viewModel.onMemberEdit(member)
                                    }
                                    Action(tint: appColor(.red), icon: "trash.fill",
                                           isEnabled: viewModel.member?.hasPermissionToManageMembers == true && member.role != .owner) {
                                        viewModel.onMemberDelete(member)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(16)
            }
            if viewModel.member?.hasPermissionToManageMembers == true {
                AppButton(style: .fill("Invite member", .lightBlue), action: .main(viewModel.onInviteMemberTapped))
                    .padding(16)
            }
        }
        .navigationTitle("Members")
    }
}
