//
//  LeaveProjectWarningView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

struct LeaveProjectWarningView: View {

    @ObservedObject var viewModel: LeaveProjectWarningViewModel

    @State private var contentHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            VStack {
                switch viewModel.context {
                case .owner: informationPage
                case .notOwner: deletionPage
                }
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
            VStack(spacing: 8) {
                Text("Before you can leave the project, you must transfer the ownership rights to another project member. This ensures continuous management and access control of the project. Please assign a new project owner before proceeding to leave.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
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
            VStack(spacing: 8) {
                Text("Please confirm if you wish to leave this project. Keep in mind that this action is irreversible. Once you leave, you will lose access to the project and will need a new invitation to rejoin.")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.center)
            .apply(.regular, size: .S, color: .white)
            VStack(spacing: 16) {
                AppButton(style: .fill("Leave project", .lightBlue), action: .async(viewModel.onLeaveProjectTapped))
                AppButton(style: .text("Cancel"), action: .main(viewModel.onCancelTapped))
            }
        }
        .padding(16)
        .padding(.top, 16)
    }
}

