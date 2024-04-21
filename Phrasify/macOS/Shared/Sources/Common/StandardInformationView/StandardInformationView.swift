//
//  StandardInformationView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 21.04.24.
//

import SwiftUI

struct StandardInformationView<ViewModel: StandardInformationProtocol>: View {

    var viewModel: ViewModel

    var body: some View {
        informationPage
            .padding(16)
            .padding(.top, 16)
            .applyCellBackground()
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
            Text(viewModel.subtitle)
                .multilineTextAlignment(.center)
                .apply(.regular, size: .S, color: .white)
            HStack {
                Spacer()
                AppButton(style: .fill("Understood", .lightBlue), action: .main(viewModel.onUnderstoodTapped))
            }
        }
    }
}
