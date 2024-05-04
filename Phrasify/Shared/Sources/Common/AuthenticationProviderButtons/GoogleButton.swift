//
//  GoogleButton.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.12.23.
//

import SwiftUI

struct GoogleButton: View {

    let action: @MainActor () -> Void

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

    private var fontSize: CGFloat {
        #if os(iOS)
            return 20
        #else
            return 12
        #endif
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Spacer()
                Image(.googleIcon)
                    #if os(macOS)
                    .resizable()
                    .frame(width: 12, height: 12)
                    #endif
                Text(text)
                    .font(.custom("Roboto-Medium", fixedSize: fontSize))
                    .foregroundStyle(fontColor)
                Spacer()
            }
            #if os(iOS)
            .frame(height: AppButton.height)
            #else
            .frame(height: AppButton.authenticationProviderButtonHeight)
            #endif
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
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        GoogleButton {
            print("XD")
        }
    }
}
