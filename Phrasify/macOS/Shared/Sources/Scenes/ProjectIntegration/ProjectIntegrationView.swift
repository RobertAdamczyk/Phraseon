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
                    AppTitle(subtitle: "Use the 'Sync Phrases' button to ensure your app's project translation keys are up-to-date. Below, you can specify the default locations for your localization files for each programming environment.")
                        .padding(.bottom, 8)
                    ForEach(viewModel.technologies, id: \.self) { technology in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(technology.title)
                                .apply(.bold, size: .M, color: .lightGray)
                            switch technology {
                            case .kotlin:
                                Text("Choose the directory where the localization files for Android are stored, typically within 'res/values'.")
                                    .apply(.regular, size: .S, color: .white)
                            case .swift:
                                Text("Identify the directory containing your Swift localization files, typically named 'en.lproj' or similar.")
                                    .apply(.regular, size: .S, color: .white)
                            }
                            AppDivider(color: .init(red: 70/255, green: 70/255, blue: 70/255), height: 1)
                            HStack(spacing: 8) {
                                Text("Path to localizations")
                                    .apply(.regular, size: .S, color: .white)
                                switch technology {
                                case .swift:
                                    TextField("", text: $viewModel.swiftPath)
                                        .apply(.regular, size: .S, color: .white)
                                        .textFieldStyle(.roundedBorder)
                                case .kotlin:
                                    TextField("", text: $viewModel.kotlinPath)
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

