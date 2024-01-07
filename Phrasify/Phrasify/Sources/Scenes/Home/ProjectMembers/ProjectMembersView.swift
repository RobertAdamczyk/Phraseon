//
//  ProjectMembersView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

struct ProjectMembersView: View {

    @ObservedObject var viewModel: ProjectMembersViewModel

    @State private var usedSections: [Role] = []

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.members, id: \.self) { member in
                        if !usedSections.contains(member.role) {
                            Text(member.role.sectionTitle)
                                .apply(.medium, size: .M, color: .lightGray)
                                .padding(.top, member.role == .owner ? 0 : 16)
                        }
                        UserDetailView(email: member.email, name: member.name, surname: member.surname, photoUrl: member.photoUrl)
                    }
                    Spacer()
                }
                .padding(16)
            }
            AppButton(style: .fill("Invite member", .lightBlue), action: .main(viewModel.onInviteMemberTapped))
                .padding(16)
        }
        .navigationTitle("Members")
    }
}
