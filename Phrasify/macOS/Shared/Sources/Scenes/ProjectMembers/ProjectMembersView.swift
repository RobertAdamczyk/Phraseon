//
//  ProjectMembersView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 20.04.24.
//

import SwiftUI
import Model

struct ProjectMembersView: View {

    @ObservedObject var viewModel: ProjectMembersViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(Role.allCases, id: \.self) { role in
                    if let membersOfRole = viewModel.groupedMembers[role], !membersOfRole.isEmpty {
                        Text(role.sectionTitle)
                            .apply(.medium, size: .M, color: .lightGray)
                            .padding(.top, role == .owner ? 0 : 16)

                        ForEach(membersOfRole, id: \.self) { member in
                            UserDetailView(email: member.email, name: member.name, surname: member.surname, photoUrl: member.photoUrl)
                                .overlay(alignment: .bottomTrailing) {
                                    makeEditButtons(member: member)
                                }
                        }
                    }
                }
            }
            .padding(32)
            .padding(.bottom, ActionBottomBarConstants.height)
        }
        .makeActionBottomBar(padding: .large, shouldVisible: viewModel.member?.hasPermissionToManageMembers == true, content: {
            Spacer()
            AppButton(style: .fill("Invite member", .lightBlue), action: .main(viewModel.onInviteMemberTapped))
        })
        .opacity(viewModel.members.isEmpty ? 0 : 1) // It can be deleted when we have loading indicator on this page.
        .navigationTitle("Members")
        .applyViewBackground()
    }

    private func makeEditButtons(member: Member) -> some View {
        HStack(spacing: 16) {
            if viewModel.member?.hasPermissionToManageMembers == true && member.role != .owner {
                Button {
                    viewModel.onMemberEdit(member)
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .apply(.medium, size: .M, color: .paleOrange)
                }
                .buttonStyle(.plain)
                Button {
                    viewModel.onMemberDelete(member)
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20, height: 22)
                        .apply(.medium, size: .M, color: .paleOrange)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .padding(.horizontal, 8)
    }
}

