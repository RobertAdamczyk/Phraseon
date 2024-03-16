//
//  ToastView.swift
//  Phraseon
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
    @State private var didAppear: Bool = false
    @State private var dragOffset: CGFloat = .zero
    @State private var toastSize: CGSize = .zero

    internal static var toastDuration: CGFloat = 3

    public var body: some View {
        VStack {
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
            .background {
                Color.clear
                    .applyCellBackground()
                    .background {
                        GeometryReader { proxy in
                            Color.clear
                                .onAppear {
                                    toastSize = proxy.size
                                    didAppear = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        performAnimation()
                                    }
                                }
                        }
                    }
                    .ignoresSafeArea()

            }
            .offset(y: startAnimation ? 0 : -toastSize.height)
            .animation(.default, value: startAnimation)
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
        .opacity(didAppear ? 1 : 0)
    }

    private func performAnimation() {
        startAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + ToastView.toastDuration) {
            startAnimation = false
        }
    }
}

#Preview {
    ZStack {
        appColor(.black)
        ToastView(type: .error, message: "aklsdjalksjdlajksdkja asdasdasd asdasdasdas sadasdasdasd sadasdas asdasdasdasd")
    }
    .overlay {
        AppButton(style: .fill("TEST", .lightBlue), action: .main({
            ToastView.showGeneralError()
        }))
    }
}
