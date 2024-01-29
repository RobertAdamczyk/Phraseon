//
//  ProjectIntegrationView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI

struct ProjectIntegrationView: View {

    @ObservedObject var viewModel: ProjectIntegrationViewModel

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    AppTitle(subtitle: "This script synchronizes phrase localizations by downloading translations from a Phrasify and saving them into your project directories.")
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Pre-requisites", systemImage: "1.circle")
                            .apply(.medium, size: .M, color: .lightGray)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ensure ") + Text("curl").bold() + Text(" and ") + Text("jq").bold() + Text(" are installed on your system.")
                        }
                        .apply(.regular, size: .M, color: .white)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .applyCellBackground()
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Configure the Script", systemImage: "2.circle")
                            .apply(.medium, size: .M, color: .lightGray)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Open the script in a text editor.")
                            Text("Locate the line RELATIVE_PATH=\"/YOUR_PATH/TO_LOCALIZATIONS\"")
                            Text("Replace with the actual path where you want the localization files to be stored.")
                        }
                        .apply(.regular, size: .M, color: .white)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .applyCellBackground()
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Label("Running the Script", systemImage: "3.circle")
                            .apply(.medium, size: .M, color: .lightGray)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Open a terminal window")
                            Text("Navigate to the directory containing the script.")
                            Text("Execute the script by typing \"sh syncPhrases.sh\" and pressing Enter.")
                            Text("The script checks for network connectivity. If offline, it will exit without synchronizing.")
                        }
                        .apply(.regular, size: .M, color: .white)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .applyCellBackground()
                    }

                }
                .padding(16)
            }
            VStack(spacing: 16) {
                AppButton(style: .fill("Export Script", .lightBlue), action: .main(viewModel.onExportTapped))
                Text("Currently the script only for macOS and Swift supported.")
                    .apply(.medium, size: .S, color: .lightGray)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
        }
        .navigationTitle("Integration")
        .fileExporter(isPresented: $viewModel.shouldShowExportSheet, document: viewModel.syncScriptFile,
                      contentType: .shellScript, defaultFilename: viewModel.defaultFilename, onCompletion: viewModel.onExportCompletion)
        .applyViewBackground()
    }
}

