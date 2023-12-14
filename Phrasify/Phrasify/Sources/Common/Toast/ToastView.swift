//
//  ToastView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

public struct ToastView: View {

    internal enum ToastType {
        case error
        case success

        var title: String {
            switch self {
            case .error: return "Error"
            case .success: return "Success"
            }
        }
    }

    let type: ToastType
    let message: String

    @State private var startAnimation: Bool = false
    @State private var dragOffset: CGFloat = .zero

    private var toastHeight: CGFloat {
        UIScreen.main.bounds.height * 0.1
    }

    internal static var toastDuration: CGFloat = 3

    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(type.title)
                        .apply(.bold, size: .H1, color: .toastErrorFont)
                    Text(message)
                        .apply(.regular, size: .M, color: .toastErrorFont)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .frame(height: toastHeight, alignment: .bottom)
            .padding(16)
            .background(appColor(.toastErrorBackground))
            .offset(y: startAnimation ? 0 : -UIScreen.main.bounds.height)
            .animation(.easeInOut.speed(0.6), value: startAnimation)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard gesture.translation.height < 0 else { return }
                        dragOffset = gesture.translation.height
                    }
                    .onEnded { _ in
                        if dragOffset < 0 {
                            startAnimation = false
                        }
                    }
            )
            Spacer()
        }
        .onAppear {
            startAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + ToastView.toastDuration) {
                startAnimation = false
            }
        }
    }
}
