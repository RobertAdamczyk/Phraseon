//
//  ProjectIntegrationView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 26.04.24.
//

import SwiftUI

struct ProjectIntegrationView: View {

    @ObservedObject var viewModel: ProjectIntegrationViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    AppTitle(subtitle: "You can synchronize translation keys with your app project on the project page using the \"Sync phrases\" button. \n\nHere, you can set the default paths to the translation directories for your app for each technology.")
                        .padding(.bottom, 8)
                    ForEach(viewModel.technologies, id: \.self) { technology in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(technology.title)
                                .apply(.bold, size: .M, color: .lightGray)
                            Text("Select the folder where the translation directories are located, such as 'en.lproj'.")
                                .apply(.regular, size: .S, color: .white)
                            AppDivider(color: .init(red: 70/255, green: 70/255, blue: 70/255), height: 1)
                            HStack(spacing: 8) {
                                Text("Path to localizations")
                                    .apply(.regular, size: .S, color: .white)
                                switch technology {
                                case .swift:
                                    TextField("", text: $viewModel.swiftPath)
                                        .apply(.regular, size: .S, color: .white)
                                        .textFieldStyle(.roundedBorder)
                                }
                            }
                            Button {
                                viewModel.onSelectPathTapped(technology)
                            } label: {
                                Text("Select path")
                            }
                        }
                        .padding(16)
                        .applyCellBackground()
                    }
                    Spacer()
                }
                .padding(32)
            }
        }
        .navigationTitle("Integration")
        .applyViewBackground()
    }
}

