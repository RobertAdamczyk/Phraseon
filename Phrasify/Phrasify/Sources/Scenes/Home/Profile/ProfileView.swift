//
//  ProfileView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 30.12.23.
//

import SwiftUI
import CachedAsyncImage

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                profileImageView
                VStack(alignment: .leading, spacing: 16) {
                    Text("Personal Info")
                        .apply(.medium, size: .M, color: .lightGray)
                    makeProfileRow(for: .email, value: viewModel.user?.email ?? "-")
                    Button(action: viewModel.onNameTapped, label: {
                        makeProfileRow(for: .name, value: viewModel.userName)
                    })
                    Button(action: viewModel.onPasswordTapped, label: {
                        makeProfileRow(for: .password, value: "********")
                    })
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("Subscription")
                        .apply(.medium, size: .M, color: .lightGray)
                    Button(action: viewModel.onMembershipTapped, label: {
                        makeProfileRow(for: .membership, value: viewModel.subscriptionValidUntil)
                    })
                }
                VStack(spacing: 16) {
                    AppButton(style: .fill("Logout", .lightBlue), action: .main(viewModel.onLogoutTapped))
                    AppButton(style: .text("Delete Account"), action: .main(viewModel.onDeleteAccountTapped))
                }
                .padding(.top, 16)
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .navigationTitle("Profile")
    }

    private var profileImageView: some View {
        PhotoPickerView(width: 80, height: 80, completion: viewModel.uploadProfileImage) { image in
            makeImage(for: image)
        } emptyLabel: {
            if let urlString = viewModel.user?.photoUrl, let url = URL(string: urlString) {
                CachedAsyncImage(url: url) { image in
                    makeImage(for: image)
                } placeholder: {
                    ProgressView()
                }
            } else {
                makeImage(for: Image(systemName: "person.crop.circle.fill"))
            }
        }
    }

    private func makeImage(for image: Image) -> some View {
        image
            .resizable()
            .clipShape(.circle)
            .padding(4)
            .background {
                Circle().fill(appColor(.white))
            }
    }
}

extension ProfileView {

    private enum ProfileItem {
        case email
        case name
        case password
        case membership

        var imageView: some View {
            switch self {
            case .email: 
                Image(systemName: "envelope.fill")
                    .resizable()
                    .frame(width: 28, height: 20)
            case .name:
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            case .password:
                Image(systemName: "lock.fill")
                    .resizable()
                    .frame(width: 14, height: 20)
            case .membership:
                Image(systemName: "person.text.rectangle.fill")
                    .resizable()
                    .frame(width: 28, height: 20)
            }
        }

        var title: String {
            switch self {
            case .email: "Email"
            case .name: "Name"
            case .password: "Password"
            case .membership: "Membership"
            }
        }

        var showChevron: Bool {
            switch self {
            case .email: false
            case .name, .password, .membership: true
            }
        }
    }

    @ViewBuilder
    private func makeProfileRow(for item: ProfileItem, value: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                item.imageView
                    .foregroundStyle(appColor(.white))
            }
            .frame(width: 28)
            VStack(alignment: .leading) {
                Text(item.title)
                    .apply(.regular, size: .S, color: .white)
                Text(value)
                    .apply(.medium, size: .S, color: .lightGray)
            }
            Spacer()
            if item.showChevron {
                Image(systemName: "chevron.forward")
                    .apply(.bold, size: .L, color: .paleOrange)
            }
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background {
            Rectangle()
                .fill(appColor(.darkGray))
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: .init(coordinator: MockCoordinator()))
    }
    .preferredColorScheme(.dark)
}
