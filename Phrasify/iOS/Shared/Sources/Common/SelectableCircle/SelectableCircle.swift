//
//  SelectableCircle.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 27.01.24.
//

import SwiftUI

struct SelectableCircle: View {

    let isSelected: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 3)
            .frame(width: 24, height: 24)
            .foregroundStyle(appColor(isSelected ? .white : .lightGray))
            .background {
                Circle()
                    .foregroundStyle(appColor(.paleOrange))
                    .padding(5)
                    .opacity(isSelected ? 1 : 0)
            }
    }
}
