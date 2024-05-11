//
//  ProjectDetailView+SyncContentView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 10.05.24.
//

import SwiftUI
import Model

extension ProjectDetailView {

    struct SyncContentView: View {

        @ObservedObject var syncManager: LocalizationSyncManager

        var body: some View {
            AppButton(style: .fill("Sync phrases", .lightBlue), action: .async(syncManager.synchronizeKeys))
                .disabled(syncManager.shouldSyncButtonDisabled)
            VStack(alignment: .leading, spacing: 4) {
                Text("For selected technology:")
                    .apply(.regular, size: .S, color: .lightGray)
                    .padding(.horizontal, 8)
                Picker("", selection: $syncManager.selectedTechnology) {
                    if syncManager.selectedTechnology == nil {
                        Text(" ").tag(nil as Technology?)
                    }
                    ForEach(syncManager.technologies, id: \.self) { technology in
                        Text("\(technology.title)").tag(technology as Technology?)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 128)
                .tint(appColor(.lightBlue))
            }
        }
    }

}
