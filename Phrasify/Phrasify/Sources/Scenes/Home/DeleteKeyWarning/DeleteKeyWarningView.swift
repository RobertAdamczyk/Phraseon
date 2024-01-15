//
//  DeleteKeyWarningView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

struct DeleteKeyWarningView: View {

    @ObservedObject var viewModel: DeleteKeyWarningViewModel

    @State private var contentHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            VStack {
                deletionPage
            }
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
        .presentationDetents(contentHeight == .zero ? [.medium] : [.height(contentHeight)])
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
            VStack(spacing: 8) {
                Text("This action is irreversible and once deleted, the phrase cannot be recovered. Please confirm if you wish to proceed with deletion.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill("Delete phrase", .lightBlue), action: .async(viewModel.onDeleteKeyTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
            }
        }
        .padding(16)
        .padding(.top, 16)
    }
}
