//
//  ProfileView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 30.12.23.
//

import SwiftUI
import Shimmer

struct ProfileView: View {

    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    ImageView(viewModel: viewModel)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Personal Info")
                            .apply(.medium, size: .M, color: .lightGray)
                        makeProfileRow(for: .email, value: viewModel.user.currentValue?.email ?? "-")
                        Button(action: viewModel.onNameTapped, label: {
                            makeProfileRow(for: .name, value: viewModel.utility.userName)
                        })
                        Button(action: viewModel.onPasswordTapped, label: {
                            makeProfileRow(for: .password, value: "********")
                        })
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Subscription")
                            .apply(.medium, size: .M, color: .lightGray)
                        Button(action: viewModel.onMembershipTapped, label: {
                            makeProfileRow(for: .membership, value: viewModel.utility.subscriptionValidUntil)
                        })
                    }
                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Logout", .lightBlue), action: .main(viewModel.onLogoutTapped))
                AppButton(style: .text("Delete Account"), action: .main(viewModel.onDeleteAccountTapped))
            }
            .padding(16)
        }
        .opacity(viewModel.utility.shouldShowContent ? 1 : 0)
        .navigationTitle("Profile")
        .disabled(viewModel.utility.shouldInteractionDisabled)
        .overlay(content: makeErrorIfNeeded)
        .redacted(reason: viewModel.utility.shouldShowLoading ? .placeholder : .invalidated)
        .shimmering(active: viewModel.utility.shouldShowLoading)
        .applyViewBackground()
    }

    @ViewBuilder
    private func makeErrorIfNeeded() -> some View {
        if viewModel.utility.shouldShowError {
            ContentUnavailableView("Error Occurred",
                                   systemImage: "exclamationmark.circle.fill",
                                   description: Text("Unable to load data. Please try again later."))
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                AppButton(style: .fill("Logout", .lightBlue), action: .main(viewModel.onLogoutTapped))
                    .padding(16)
            }
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
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            if item.showChevron {
                Image(systemName: "chevron.forward")
                    .apply(.bold, size: .L, color: .paleOrange)
            }
        }
        .padding(.horizontal, 8)
        .padding(8)
        .applyCellBackground()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ProfileView(viewModel: .init(coordinator: PreviewCoordinator()))
    }
    .preferredColorScheme(.dark)
}
#endif
