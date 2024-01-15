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
                VStack(alignment: .leading, spacing: 16) {
                    AppTitle(subtitle: "This script is designed to synchronize phrase localizations. It ensures that your app's language translations are up-to-date.")
                }
                .padding(16)
            }
            AppButton(style: .fill("Export Script", .lightBlue), action: .main(viewModel.onExportTapped))
                .padding(16)
        }
        .navigationTitle("Export Script")
        .fileExporter(isPresented: $viewModel.shouldShowExportSheet, document: viewModel.syncScriptFile, 
                      contentType: .shellScript, defaultFilename: viewModel.defaultFilename, onCompletion: viewModel.onExportCompletion)
    }
}

