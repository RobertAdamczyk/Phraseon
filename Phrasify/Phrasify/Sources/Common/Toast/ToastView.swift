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

        var imageName: String {
            switch self {
            case .error: return "exclamationmark.triangle.fill"
            case .success: return "checkmark.circle.fill"
            }
        }

        var color: AppColor {
            switch self {
            case .error: return .paleOrange
            case .success: return .green
            }
        }
    }

    let type: ToastType
    let message: String

    @State private var startAnimation: Bool = false
    @State private var dragOffset: CGFloat = .zero
    @State private var toastSize: CGSize = .zero

    private var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }

    internal static var toastDuration: CGFloat = 3

    public var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Label {
                        Text(message)
                            .apply(.medium, size: .M, color: .white)
                            .fixedSize(horizontal: false, vertical: true)
                    } icon: {
                        Image(systemName: type.imageName)
                            .apply(.semibold, size: .H1, color: type.color)
                    }
                }
                Spacer()
            }
            .padding(16)
            .padding(.top, safeAreaInsets.top)
            .background(appColor(.darkGray))
            .clipShape(.rect(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
            .offset(y: startAnimation ? toastSize.height : 0)
            .animation(.easeInOut, value: startAnimation)
            .offset(y: dragOffset)
            .background {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            toastSize = proxy.size
                        }
                }
            }
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
        }
        .onAppear {
            startAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + ToastView.toastDuration) {
                startAnimation = false
            }
        }
        .offset(y: -UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        appColor(.black)
        ToastView(type: .error, message: "aklsdjalksjdlajksdkja")
    }
}
