//
//  ProfileDeleteWarningView.swift
//  Phraseon
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
            Text(viewModel.informationPageTitle)
                .apply(.bold, size: .H1, color: .white)
            VStack(alignment: .leading, spacing: 8) {
                Label(viewModel.informationPageDescription, systemImage: "1.circle")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            Spacer()
            AppButton(style: .fill(viewModel.informationPageButtonTitle, .lightBlue), action: .main(viewModel.onUnderstoodTapped))
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
            Text(viewModel.deletionPageTitle)
                .apply(.bold, size: .H1, color: .white)
            VStack(alignment: .leading, spacing: 8) {
                Label(viewModel.deletionPageDescription1, systemImage: "1.circle")
                    .fixedSize(horizontal: false, vertical: true)
                Label(viewModel.deletionPageDescription2, systemImage: "2.circle")
                    .fixedSize(horizontal: false, vertical: true)
                Label(viewModel.deletionPageDescription3, systemImage: "3.circle")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill(viewModel.deletionPageButtonDeleteAccountTitle, .lightBlue), action: .async(viewModel.onDeleteAccountTapped))
                AppButton(style: .text(viewModel.deletionPageButtonCancelTitle), action: .main(viewModel.onCancelTapped))
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
