//
//  ProfileDeleteWarningView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 03.01.24.
//

import SwiftUI

struct ProfileDeleteWarningView: View {

    @ObservedObject var viewModel: ProfileDeleteWarningViewModel

    @State private var contentHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .applyCellBackground()
                    .ignoresSafeArea()
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            deletionPage
                                .frame(width: geometry.size.width)
                                .id(ProfileDeleteWarningViewModel.State.deletion.rawValue)
                            informationPage
                                .frame(width: geometry.size.width)
                                .id(ProfileDeleteWarningViewModel.State.information.rawValue)
                        }
                        .scrollTargetLayout()
                    }
                    .applyCellBackground()
                    .scrollDisabled(true)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .onAppear { setupScrollingAction(proxy) }
                }
            }
        }
        .presentationDetents(contentHeight == .zero ? [.medium] : [.height(contentHeight)])
    }

    @ViewBuilder
    private var informationPage: some View {
        VStack(spacing: 32) {
            Image(systemName: "info.square.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundStyle(appColor(.paleOrange))
            Text("Action Required")
                .apply(.bold, size: .H1, color: .white)
            VStack(alignment: .leading, spacing: 8) {
                Label("As you are currently owning a project, you must either transfer ownership to another user or delete the project before you can delete your account. Owning a project prevents account deletion.", systemImage: "1.circle")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            Spacer()
            AppButton(style: .fill("Understood", .lightBlue), action: .main(viewModel.onUnderstoodTapped))
        }
        .padding(16)
        .padding(.top, 16)
    }

    private var deletionPage: some View {
        VStack(spacing: 32) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundStyle(appColor(.paleOrange))
            Text("Are you sure ?")
                .apply(.bold, size: .H1, color: .white)
            VStack(alignment: .leading, spacing: 8) {
                Label("Deleting your account will instantly remove you from current projects.", systemImage: "1.circle")
                    .fixedSize(horizontal: false, vertical: true)
                Label("Active subscriptions will be cancelled without the possibility of renewal.", systemImage: "2.circle")
                    .fixedSize(horizontal: false, vertical: true)
                Label("The account deletion process is irreversible, and you will not be able to regain access to your account or its data.", systemImage: "3.circle")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill("Delete Account", .lightBlue), action: .async(viewModel.onDeleteAccountTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
                    .opacity(viewModel.state == .deletion ? 1 : 0)
            }
        }
        .padding(16)
        .padding(.top, 16)
        .background() {
            GeometryReader { geometry in
                Path { path in
                    DispatchQueue.main.async {
                        contentHeight = geometry.size.height
                    }
                }
            }
        }
    }

    private func setupScrollingAction(_ proxy: ScrollViewProxy) {
        viewModel.scrollToPageAction = { state in
            withAnimation(.snappy) {
                proxy.scrollTo(state.rawValue, anchor: .leading)
            }
        }
    }
}
