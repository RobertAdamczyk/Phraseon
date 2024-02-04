//
//  ProjectDetailView+KeyRow.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI

extension ProjectDetailView {

    struct KeyRow: View {

        let key: Key
        let viewModel: ProjectDetailViewModel

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(key.id ?? "")
                        .apply(.medium, size: .M, color: .white)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(key.lastUpdatedAt.timeAgo)
                        if viewModel.translationApprovalUseCase.shouldShow {
                            Rectangle()
                                .frame(width: 2)
                                .foregroundStyle(appColor(.lightGray))
                                .padding(.horizontal, 8)
                            Text(key.keyStatus.localizedTitle)
                        }
                    }
                    .apply(.medium, size: .S, color: .lightGray)
                }
                Spacer()
                Image(systemName: "chevron.forward")
                    .apply(.bold, size: .L, color: .paleOrange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .padding(.horizontal, 8)
            .applyCellBackground()
        }
    }
}

#if DEBUG
#Preview {
    ZStack {
        appColor(.black)
        ProjectDetailView.KeyRow(key: .init(id: "test_key", translation: [:], createdAt: .now, lastUpdatedAt: .distantPast,
                                            status: ["EN": KeyStatus.approved]), viewModel: .init(coordinator: MockCoordinator(), project: .init(name: "", technologies: [], languages: [], baseLanguage: .english, members: [], owner: "das")))
            .padding(16)
    }
}
#endif
