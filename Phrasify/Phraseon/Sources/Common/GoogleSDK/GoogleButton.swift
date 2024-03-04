//
//  GoogleButton.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.12.23.
//

import SwiftUI

struct GoogleButton: View {

    let action: () -> Void

    private let fillColor: Color = .init(red: 0.07450980392156863, 
                                         green: 0.07450980392156863,
                                         blue: 0.0784313725490196)
    private let strokeColor: Color = .init(red: 0.5568627450980392, 
                                           green: 0.5686274509803921,
                                           blue: 0.5607843137254902)
    private let fontColor: Color = .init(red: 0.8901960784313725, 
                                         green: 0.8901960784313725,
                                         blue: 0.8901960784313725)

    private let text: String = "Continue with Google"

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Spacer()
                Image(.googleIcon)
                Text(text)
                    .font(.custom("Roboto-Medium", fixedSize: 14))
                    .foregroundStyle(fontColor)
                Spacer()
            }
            .frame(height: AppButton.height)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(fillColor)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(strokeColor)
            }
        }
    }
}

#Preview {
    ZStack {
        GoogleButton {
            print("XD")
        }
    }
}
