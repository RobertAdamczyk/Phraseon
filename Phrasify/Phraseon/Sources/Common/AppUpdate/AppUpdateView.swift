//
//  AppUpdateView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 16.02.24.
//

import SwiftUI

struct AppUpdateView: View {

    let title: String
    let message: String
    let confirmButtonText: String
    let url: String

    var body: some View {
        ZStack {
            appColor(.black).opacity(0.6).ignoresSafeArea()
            VStack(spacing: 0) {
                if let image = UIImage(named: "AppIcon") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 64)
                        .clipShape(Circle())
                        .padding(2)
                        .background {
                            Circle()
                                .fill(appColor(.lightGray))
                        }
                }
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text(title)
                            .apply(.semibold, size: .L, color: .white)
                        Text(message)
                            .apply(.medium, size: .S, color: .lightGray)
                    }
                    .multilineTextAlignment(.center)
                    VStack(spacing: 16) {
                        AppButton(style: .fill(confirmButtonText, .lightBlue), action: .main({
                            guard let url = URL(string: url) else { return }
                            UIApplication.shared.open(url)
                        }))
                    }
                }
                .padding(32)
                .applyCellBackground()
                .padding(16)
            }
        }
    }
}

#Preview {
    ZStack {
        HomeView(coordinator: MockCoordinator())
        AppUpdateView(title: "We are better than ever",
                      message: "Please download the latest app version from the App Store.",
                      confirmButtonText: "Update", 
                      url: "http://www.google.com")
    }
}
