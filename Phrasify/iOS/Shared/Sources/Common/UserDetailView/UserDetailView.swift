//
//  UserDetailView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI
import CachedAsyncImage

struct UserDetailView: View {

    let email: String?
    let name: String?
    let surname: String?
    let photoUrl: String?

    private var hasName: Bool {
        return (name?.isEmpty == false) || (surname?.isEmpty == false)
    }

    private var fullName: String {
        let fullNameParts = [name ?? "", surname ?? ""].filter { !$0.isEmpty }
        return fullNameParts.joined(separator: " ")
    }

    var body: some View {
        makeUserRow(email: email, name: name, surname: surname, photoUrl: photoUrl)
    }

    @ViewBuilder
    private func makeUserRow(email: String?, name: String?, surname: String?, photoUrl: String?) -> some View {
        HStack(spacing: 16) {
            ZStack {
                if let photoUrl = photoUrl {
                    CachedAsyncImage(url: .init(string: photoUrl), urlCache: URLCache.imageCache, content: makeImage) {
                        makeImage()
                    }
                } else {
                    makeImage()
                }
            }
            VStack(alignment: .leading) {
                if hasName {
                    Text(fullName)
                        .apply(.regular, size: .S, color: .white)
                    Text(email ?? "No email address")
                        .apply(.medium, size: .S, color: .lightGray)
                } else {
                    Text(email ?? "No email address")
                        .apply(.regular, size: .S, color: .white)
                    Text("placeholder")
                        .apply(.medium, size: .S, color: .lightGray)
                        .opacity(0)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(8)
        .applyCellBackground()
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
