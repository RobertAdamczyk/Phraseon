//
//  UserDetailView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import CachedAsyncImage

struct UserDetailView: View {

    let email: String
    let name: String
    let surname: String
    let photoUrl: String?

    var body: some View {
        makeUserRow(email: email, name: name, surname: surname, photoUrl: photoUrl)
    }

    @ViewBuilder
    private func makeUserRow(email: String, name: String, surname: String, photoUrl: String?) -> some View {
        HStack(spacing: 16) {
            ZStack {
                if let photoUrl = photoUrl {
                    CachedAsyncImage(url: .init(string: photoUrl), content: makeImage) {
                        makeImage()
                    }
                } else {
                    makeImage()
                }
            }
            VStack(alignment: .leading) {
                Text(name + " " + surname)
                    .apply(.regular, size: .S, color: .white)
                Text(email)
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
