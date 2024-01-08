//
//  DeleteProjectWarningView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 08.01.24.
//

import SwiftUI

struct DeleteProjectWarningView: View {

    @ObservedObject var viewModel: DeleteProjectWarningViewModel

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
                Text("Please be aware that deleting a project is a permanent action and cannot be undone. By proceeding with this action, the project will be permanently removed, and all members will lose access to it.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill("Delete project", .lightBlue), action: .async(viewModel.onDeleteProjectTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
            }
        }
        .padding(16)
        .padding(.top, 16)
    }
}


