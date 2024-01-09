//
//  DeleteMemberWarningView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 09.01.24.
//

import SwiftUI

struct DeleteMemberWarningView: View {

    @ObservedObject var viewModel: DeleteMemberWarningViewModel

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
                Text("The member will lose all access to the project resources and data. Please confirm if you wish to proceed with the removal.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill("Delete member", .lightBlue), action: .async(viewModel.onDeleteMemberTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
            }
        }
        .padding(16)
        .padding(.top, 16)
    }
}



