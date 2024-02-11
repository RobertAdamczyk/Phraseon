//
//  StandardWarningView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

struct StandardWarningView<ViewModel: StandardWarningProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    @State private var contentHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .applyCellBackground()
                    .ignoresSafeArea()
                deletionPage
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
        }
        .presentationDetents(contentHeight == .zero ? [.medium] : [.height(contentHeight)])
        .interactiveDismissDisabled(viewModel.isLoading)
    }

    private var deletionPage: some View {
        VStack(spacing: 32) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .foregroundStyle(appColor(.paleOrange))
            Text(viewModel.title)
                .apply(.bold, size: .H1, color: .white)
            VStack(spacing: 8) {
                Text(viewModel.subtitle)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
                    .opacity(viewModel.isLoading ? 0 : 1)
            }
        }
        .padding(16)
        .padding(.top, 16)
    }
}

