//
//  ProjectDetailView+KeyRow.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 29.12.23.
//

import SwiftUI
import Model

extension ProjectDetailView {

    struct KeyRow: View {

        let key: Key
        let shouldShowReviewStatus: Bool

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(key.id ?? "")
                        .apply(.medium, size: .M, color: .white)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(key.lastUpdatedAt.timeAgo)
                        if shouldShowReviewStatus {
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

    struct AlgoliaKeyRow: View {

        let key: AlgoliaKey
        let shouldShowReviewStatus: Bool

        var keyId: AttributedString {
            var attributedString = AttributedString(key.keyId)

            if key.highlightResult.keyId.matchLevel != .none {

                key.highlightResult.keyId.value.extractedTexts.forEach {
                    if let range = attributedString.range(of: $0) {
                        attributedString[range].foregroundColor = appColor(.white)
                    }
                }
            } else {
                attributedString.foregroundColor = appColor(.white)
            }
            return attributedString
        }

        var translation: AttributedString? {
            guard let highlightTranslation = key.highlightResult.translation.first(where: { $0.value.matchLevel != .none }),
                  let translation = key.translation[highlightTranslation.key] else {
                return nil
            }
            var attributedString = AttributedString(translation)

            highlightTranslation.value.value.extractedTexts.forEach {
                if let range = attributedString.range(of: $0) {
                    attributedString[range].foregroundColor = appColor(.white)
                }
            }

            return attributedString
        }

        var body: some View {
            HStack {
                LazyVStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(keyId)
                            .apply(.medium, size: .M, color: .lightGray)
                            .multilineTextAlignment(.leading)
                        if let translation {
                            Text(translation)
                                .apply(.regular, size: .S, color: .lightGray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(Date(timeIntervalSince1970: TimeInterval(key.lastUpdatedAt.seconds)).timeAgo)
                        if shouldShowReviewStatus {
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
        VStack {
            ProjectDetailView.KeyRow(key: .init(id: "test_key", 
                                                translation: [:],
                                                createdAt: .now, 
                                                lastUpdatedAt: .distantPast,
                                                status: ["EN": KeyStatus.approved]), 
                                     shouldShowReviewStatus: true)
            ProjectDetailView.AlgoliaKeyRow(key: .init(createdAt: .init(seconds: 100000,
                                                                        nanoseconds: 10000),
                                                       lastUpdatedAt: .init(seconds: 10000,
                                                                            nanoseconds: 100000),
                                                       status: [:],
                                                       translation: ["EN": "Hello world !"],
                                                       keyId: "keyid",
                                                       projectId: "",
                                                       objectID: "asasdaasdas_sdasdasd_SdasdasdA_Sdasdasda",
                                                       highlightResult: .init(keyId: .init(value: .init(string: "<em>ey</em>id"),
                                                                                           matchLevel: .full,
                                                                                           matchedWords: []),
                                                                              translation: ["EN": .init(value: .init(string: "He<em>llo w</em>orld !"),
                                                                                                        matchLevel: .full,
                                                                                                        matchedWords: ["zamkn"])])),
                                            shouldShowReviewStatus: true)
        }
        .padding(16)
    }
}
#endif
