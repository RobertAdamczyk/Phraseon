//
//  ProjectMembersView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI
import CachedAsyncImage

struct ProjectMembersView: View {

    @ObservedObject var viewModel: ProjectMembersViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(viewModel.members, id: \.self) { member in
                    makeMemberRow(for: member)
                }
            }
            .padding(16)
        }
        .navigationTitle("Members")
    }

    @ViewBuilder
    private func makeMemberRow(for member: Member) -> some View {
        HStack(spacing: 16) {
            ZStack {
                if let photoUrl = member.photoUrl {
                    CachedAsyncImage(url: .init(string: photoUrl), content: makeImage) {
                        makeImage()
                    }
                } else {
                    makeImage()
                }
            }
            VStack(alignment: .leading) {
                Text(member.name + " " + member.surname)
                    .apply(.regular, size: .S, color: .white)
                Text(member.email)
                    .apply(.medium, size: .S, color: .lightGray)
            }
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background {
            Rectangle()
                .fill(appColor(.darkGray))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func makeImage(for image: Image = Image(systemName: "person.crop.circle.fill")) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(.circle)
            .padding(2)
            .overlay {
                Circle()
                    .stroke(lineWidth: 2)
                    .fill(appColor(.white))
            }
    }
}
