//
//  StandardInformationView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

struct StandardInformationView<ViewModel: StandardInformationProtocol>: View {

    var viewModel: ViewModel

    @State private var contentHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .applyCellBackground()
                    .ignoresSafeArea()
                informationPage
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
    }

    @ViewBuilder
    private var informationPage: some View {
        VStack(spacing: 32) {
            Image(systemName: "info.square.fill")
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
            AppButton(style: .fill("Understood", .lightBlue), action: .main(viewModel.onUnderstoodTapped))
        }
        .padding(16)
        .padding(.top, 16)
    }
}


