//
//  StandardWarningView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 14.04.24.
//

import SwiftUI

struct StandardWarningView<ViewModel: StandardWarningProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        deletionPage
            .padding(16)
            .padding(.top, 16)
            .interactiveDismissDisabled(viewModel.isLoading)
            .applyCellBackground()
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
            Text(viewModel.subtitle)
                .multilineTextAlignment(.center)
                .apply(.regular, size: .S, color: .white)
            HStack(spacing: 16) {
                Spacer()
                AppButton(style: .fill("Cancel", .lightGray), action: .main(viewModel.onCancelTapped))
                    .opacity(viewModel.isLoading ? 0 : 1)
                AppButton(style: .fill(viewModel.buttonText, .lightBlue), action: .async(viewModel.onPrimaryButtonTapped))
            }
        }
    }
}


