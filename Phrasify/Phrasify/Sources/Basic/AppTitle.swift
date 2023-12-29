//
//  AppTitle.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 20.12.23.
//

import SwiftUI

struct AppTitle: View {

    let title: String?
    let subtitle: String?

    init(title: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title {
                Text(title)
                    .apply(.bold, size: .H1, color: .white)
            }

            if let subtitle {
                Text(subtitle)
                    .apply(.regular, size: .M, color: .white)
            }
        }
    }
}
