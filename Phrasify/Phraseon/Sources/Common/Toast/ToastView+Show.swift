//
//  Toast.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

extension ToastView {

    private static func show(toast: ToastView) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }


        let hostingController = UIHostingController(rootView: toast)
        hostingController.view.backgroundColor = .clear

        let toastWindow = PassthroughWindow(windowScene: windowScene)
        toastWindow.windowLevel = .alert + 1
        toastWindow.rootViewController = hostingController
        toastWindow.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + ToastView.toastDuration + 1) {
            toastWindow.isHidden = true
        }
    }

    public static func showError(message: String?) {
        guard let message else {
            showGeneralError()
            return
        }
        let toastToShow = ToastView(type: .error, message: message)
        show(toast: toastToShow)
    }

    public static func showSuccess(message: String) {
        let toastToShow = ToastView(type: .success, message: message)
        show(toast: toastToShow)
    }

    public static func showGeneralError() {
        let message = "An unexpected error occurred. Please try again later. If the problem persists, contact our support team."
        let toastToShow = ToastView(type: .error, message: message)
        show(toast: toastToShow)
    }
}

private class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)

        // Przekazuj dotknięcia, jeśli nie dotyczą one bezpośrednio ToastView
        if hitView == self.rootViewController?.view {
            return nil
        }
        return hitView
    }
}
