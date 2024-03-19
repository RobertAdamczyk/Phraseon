//
//  Toast.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

extension ToastView {

    static func displayOnScreen(toast: ToastView) {
        DispatchQueue.main.async {
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
